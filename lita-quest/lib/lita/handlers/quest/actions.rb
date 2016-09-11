module Lita::Handlers
  module Actions
    attr_accessor :pin_tryes
    EXCLUDE_METHODS = [:results, :restart, :check_timer, :check_game_over, :time_left].freeze

    def self.before(*names)
      names.each do |name|
        m = instance_method(name)
        define_method(name) do |*args, &block|
          yield(args.first)
          m.bind(self).call(*args, &block)
        end
      end
    end

    def start(response)
      response.reply("Hello #{response.user.name}. You don't know me. But, I know you. I want to play a game.")
      response.reply("Look around #{response.user.name}. You have 5 minutes to escape room. Better hurry up.")
      sleep 2
      start_time = Time.now.utc + 305
      REDIS.set(response.user.name + '_start_time', start_time)
      every(60) do |timer|
        check_timer(response, timer)
        check_game_over(response, start_time) if timer.to_yaml.split("\n")[3].split(':').last.strip == 'true'
      end
      robot.chat_service.send_keyboard(
        response.message.source, 'The clock starts ticking. Now.', ['/look_around']
      )
    end

    def restart(response)
      REDIS.set(response.user.name, nil)
    end

    def finish(response)
      REDIS.set(response.user.name, 'win')
      response.reply('You win. Check `/results`')
    end

    def results(response)
      results = DB[:score_board].limit(10).order(:time).all
      results.map do |result|
        result[:time] = result[:time].strftime('%M:%S') if result[:time]
        result.delete(:id).to_s
      end
      response.reply("```text #{results.join("\n")} ```")
    end

    ###########################################################

    def look_around(response)
      robot.chat_service.send_keyboard(
        response.message.source,
        'You see small room with door and without windows. Room full of Nazi symbols.
        In the center, you see two chairs. On the right wall you see portrait. Near the left wall - table.',
        ['/go_to_chairs', '/go_to_left_wall', '/go_to_right_wall']
      )
    end

    def go_to_chairs(response)
      robot.chat_service.send_keyboard(
        response.message.source,
        'You get close to chairs. Left has sharp peaks. Right - horny dildos.',
        ['/sit_on_left', '/sit_on_right', '/go_back']
      )
    end

    def sit_on_left(response)
      robot.chat_service.send_keyboard(
        response.message.source,
        'The peaks extremely sharp. Are you sure?',
        ['/yes_please', '/look_around']
      )
    end

    def yes_please(response)
      REDIS.set(response.user.name, 'game_over')
      DB[:score_board].insert(player: response.user.name, time: time_left(response), additions: 'Wrong chair')
      response.reply('You die in agony. My congratulations.')
    end

    def sit_on_right(response)
      REDIS.set(response.user.name, 'win')
      DB[:score_board].insert(player: response.user.name, time: time_left(response), additions: 'Shame on you')
      response.reply('You fell pain and shame. Door is open and you can escape, but it was worth it?')
    end

    def go_to_left_wall(response)
      robot.chat_service.send_keyboard(
        response.message.source,
        'On the table you see two discharged phones. Only one plug. Choose Iphone or Android.',
        ['/iphone', '/android']
      )
    end

    def iphone(response)
      REDIS.set(response.user.name + '_pin_tryes', 0)
      robot.chat_service.send_keyboard(
        response.message.source,
        'You wait few minutes and Iphone is turns on. Enter PIN code. You have 3 attempts',
        ['/0000', '/1111', '/1234', '/4321']
      )
    end

    def pin_0000(response)
      pin_tryes = REDIS.incr(response.user.name + '_pin_tryes')
      return pin_fail(response) if pin_tryes >= 3
      robot.chat_service.send_keyboard(
        response.message.source,
        'Wrong. Try again',
        ['/0000', '/1111', '/1234', '/4321']
      )
    end

    def pin_1111(response)
      pin_tryes = REDIS.incr(response.user.name + '_pin_tryes')
      return pin_fail(response) if pin_tryes >= 3
      robot.chat_service.send_keyboard(
        response.message.source,
        'Wrong. Try again',
        ['/0000', '/1111', '/1234', '/4321']
      )
    end

    def pin_1234(response)
      pin_tryes = REDIS.incr(response.user.name + '_pin_tryes')
      return pin_fail(response) if pin_tryes >= 3
      robot.chat_service.send_keyboard(
        response.message.source,
        'Wrong. Try again',
        ['/0000', '/1111', '/1234', '/4321']
      )
    end

    def pin_4321(response)
      pin_tryes = REDIS.incr(response.user.name + '_pin_tryes')
      return pin_fail(response) if pin_tryes >= 3
      robot.chat_service.send_keyboard(
        response.message.source,
        'Wrong. Try again',
        ['/0000', '/1111', '/1234', '/4321']
      )
    end

    def pin_1488(response)
      pin_tryes = REDIS.get(response.user.name + '_pin_tryes')
      return pin_fail(response) if pin_tryes.to_i >= 3
      robot.chat_service.send_keyboard(
        response.message.source,
        'Iphone is unlocked. You see 卐 on desktop background and few apps:',
        ['/deutschlandlied', '/selbstzerstörung', '/entfliehen']
      )
    end

    def anthem(response)
      robot.chat_service.send_keyboard(
        response.message.source,
        'From the speakers came the national anthem of the Third Reich',
        ['/try_another_app', '/look_around']
      )
    end

    def self_destruction(response)
      REDIS.set(response.user.name, 'game_over')
      DB[:score_board].insert(player: response.user.name, time: time_left(response), additions: 'He did not know the German')
      response.reply('You hear siren and countdown of self-destruction. Bye-bye.')
    end

    def escape(response)
      REDIS.set(response.user.name, 'win')
      DB[:score_board].insert(player: response.user.name, time: time_left(response), additions: 'Glückwünsche!')
      response.reply('You run right application, that open door. You free!')
    end

    def pin_fail(response)
      response.reply('You used last try and Iphone is locked. Try to `/look_around`')
    end

    def android(response)
      REDIS.set(response.user.name, 'game_over')
      DB[:score_board].insert(player: response.user.name, time: time_left(response), additions: 'Wrong phone')
      response.reply('Wrong. You plug Samsung Galaxy Note 7, he ignited, burning the entire room. You dead.')
    end

    def go_to_right_wall(response)
      robot.chat_service.send_keyboard(
        response.message.source,
        'You see Bandera portrait. He smiling and you see sun over the right shoulder',
        ['/say_slava_ukraine', '/try_open_portrait', '/look_around']
      )
    end

    def say_slava_ukraine(response)
      response.reply('You hear "Heroyam Slava!" and anthem from speakers. Door is still closed. Zrada.')
    end

    def try_open_portrait(response)
      response.reply('')
    end

    def zigulenki(response)
      REDIS.set(response.user.name, 'win')
      DB[:score_board].insert(player: response.user.name, time: time_left(response), additions: 'Zigulenki')
      response.reply('Portrait winks and makes the photo. The door opens. Freedom for a photo in social networks. Zashkvar')
    end

    def check_timer(response, timer)
      case REDIS.get(response.user.name)
      when 'game_over'
        timer.stop
        DB[:score_board].insert(player: response.user.name, additions: 'Game Over')
        return response.reply('You lose. Game Over. Bye.')
      when 'win'
        return timer.stop
      end
    end

    def check_game_over(response, start_time)
      time = start_time - Time.now.utc
      if time.negative?
        REDIS.set(response.user.name, 'game_over')
      else
        rem_time = (time / 60).to_i.zero? ? time.to_s + ' seconds' : (time / 60).to_i.to_s + ' minutes'
        response.reply(rem_time + ' remaining')
      end
    end

    def time_left(response)
      Time.new(REDIS.get(response.user.name + '_start_time')).utc - Time.now.utc.to_i
    end

    before(*instance_methods - EXCLUDE_METHODS) do |response|
      case REDIS.get(response.user.name)
      when 'win'
        return response.reply('You win. Maybe next time. Check `/results`')
      when 'game_over'
        return response.reply('You had only one attempt. Bye. Check `/results` other luckies')
      end
    end
  end
end

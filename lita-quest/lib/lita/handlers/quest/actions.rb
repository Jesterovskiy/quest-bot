module Lita::Handlers
  module Actions
    attr_accessor :game_over

    def self.before(*names)
      names.each do |name|
        m = instance_method(name)
        define_method(name) do |*args, &block|
          yield(self, args.first)
          m.bind(self).call(*args, &block)
        end
      end
    end

    def start(response)
      @game_over = false
      response.reply("Hello #{response.user.name}. You don't know me. But, I know you. I want to play a game.")
      response.reply("Look around #{response.user.name}. You have 5 minutes to escape room. Better hurry up.")
      sleep 2
      @start_time = Time.now + 10 #305
      every(60) do |timer|
        if @game_over
          timer.stop
          response.reply('You lose. Game Over. Bye.')
          DB[:score_board].insert(player: response.user.name, additions: 'Game Over')
        end
        time = @start_time - Time.now
        if time.negative?
          @game_over = true
        else
          rem_time = (time / 60).to_i.zero? ? time.to_s + ' seconds' : (time / 60).to_i.to_s + ' minutes'
          response.reply(rem_time + ' remaining')
        end
      end
      robot.chat_service.send_keyboard(
        response.message.source, 'The clock starts ticking. Now.', ['/look_around']
      )
    end

    def finish(response)
      response.reply('You win. Check `/results`')
    end

    def results(response)
      binding.pry
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
        'You see small room with door and without windows. In the center there are two chairs.
        On the right wall you see portrait. On the left - table with food.',
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

    def go_to_left_wall(response)

    end

    def go_to_right_wall(response)

    end

    before(*instance_methods - [:start, :results]) do |quest, response|
      return response.reply('Run `/start` first') if @game_over
    end
  end
end

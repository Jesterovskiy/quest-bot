module Lita::Handlers
  module Actions
    module BaseActions
      def start(response)
        return response.reply('You already in game. Try to escape.') if REDIS.get(response.user.name) == 'start'
        REDIS.set(response.user.name, 'start')
        response.reply("Hello #{response.user.name}. You came for a gift. Many tried.")
        response.reply("You don't know me. But, I know you. I want to play a game.")
        response.reply("Look around #{response.user.name}. You have 5 minutes to escape room. Better hurry up.")
        sleep 2
        start_time = Time.now.utc + 310
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
        REDIS.set(response.user.name + '_pin_tryes', 0)
        REDIS.set(response.user.name + '_saw', false)
        REDIS.set(response.user.name, 'restart')
      end

      def finish(response)
        REDIS.set(response.user.name, 'win')
        robot.chat_service.send_keyboard(
          response.message.source, 'You win. Get your presents',
          ['/presents']
        )
      end

      def results(response)
        results = DB[:score_board].where(status: 'win').limit(10).order(:time).reverse.all
        if results.empty?
          response.reply('Nobody escape. See 10 latest losers:')
          results = DB[:score_board].limit(10).order(:time).reverse.all
        end
        results.map do |result|
          if result[:time]
            seconds = result[:time].min * 60 + result[:time].sec
            result[:time] = Time.at(310 - seconds).utc.strftime("%M:%S")
          end
          result.delete(:id).to_s
        end
        response.reply("```text #{results.join("\n")} ```")
      end

      def look_around(response)
        robot.chat_service.send_keyboard(
          response.message.source,
          'You see small room with door and without windows. Room full of game posters and hats.
          In the center, you see two chairs. On the right wall you see portrait. Near the left wall - table.',
          ['/go_to_chairs', '/go_to_left_wall', '/go_to_right_wall']
        )
      end

      def check_timer(response, timer)
        case REDIS.get(response.user.name)
        when 'game_over'
          timer.stop
          DB[:score_board].insert(player: response.user.name, status: 'lose', additions: 'Game Over')
          return response.reply('You lose. Game Over. Get your `/presents`. Bye.')
        when 'win'
          return timer.stop
        when 'restart'
          return timer.stop
        end
      end

      def check_game_over(response, start_time)
        time = start_time - Time.now.utc
        if time.negative?
          REDIS.set(response.user.name, 'game_over')
        else
          rem_time = (time / 60).to_i.zero? ? time.to_s.to_i + ' seconds' : (time / 60).to_i.to_s + ' minutes'
          response.reply(rem_time + ' remaining')
        end
      end

      def time_left(response)
        Time.parse(REDIS.get(response.user.name + '_start_time')).utc - Time.now.utc.to_i
      end

      def presents(response)
        presents = ['123123', '321321', '14881488', 'gAbEnPiDoR!11']
        response.reply("```text#{presents.join("\n")} ```")
        response.reply("Something went wrong. Please be patience and wait for solving problem. We notify you on email.")
      end

      def gaben(response)
        response.reply("You smart little bastard. Take your `/presents` and fuck off!")
      end
    end
  end
end

module Lita::Handlers
  module Actions
    module Chairs
      def go_to_chairs(response)
        array = ['/sit_on_left', '/sit_on_right']
        array << (REDIS.get(response.user.name + '_saw') == 'true' ? '/use_saw' : '/look_around')
        robot.chat_service.send_keyboard(
          response.message.source,
          'You get close to chairs. Left has sharp peaks. Right - horny dildos.',
          array
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
        DB[:score_board].insert(player: response.user.name, time: time_left(response), status: 'lose', additions: 'Wrong chair')
        robot.chat_service.send_keyboard(
          response.message.source,
          'You die in agony. My congratulations.',
          ['/results']
        )
      end

      def sit_on_right(response)
        REDIS.set(response.user.name, 'win')
        DB[:score_board].insert(player: response.user.name, time: time_left(response), status: 'win', additions: 'Shame on you')
        robot.chat_service.send_keyboard(
          response.message.source,
          'You fell pain and shame. Door is open and you can escape, but it was worth it?',
          ['/results']
        )
      end

      def use_saw(response)
        REDIS.set(response.user.name, 'win')
        DB[:score_board].insert(player: response.user.name, time: time_left(response), status: 'win', additions: 'Smart guy')
        robot.chat_service.send_keyboard(
          response.message.source,
          'You cut down horny dildos and sit on the chair. Door opens. You free!',
          ['/results']
        )
      end
    end
  end
end

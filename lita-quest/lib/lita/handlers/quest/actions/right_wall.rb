module Lita::Handlers
  module Actions
    module RightWall
      def go_to_right_wall(response)
        robot.chat_service.send_keyboard(
          response.message.source,
          'You see Bandera portrait. He smiling and you see sun over the right shoulder',
          ['/say_slava_ukraine', '/try_open_portrait', '/look_around']
        )
      end

      def say_slava_ukraine(response)
        robot.chat_service.send_keyboard(
          response.message.source,
          'You hear "Heroyam Slava!" and anthem from speakers. Door is still closed. Zrada.',
          ['/say_slava_ukraine', '/try_open_portrait', '/look_around']
        )
      end

      def try_open_portrait(response)
        REDIS.set(response.user.name + '_saw', true)
        robot.chat_service.send_keyboard(
          response.message.source,
          'You open portrait and in a recess lies the saw. You take it. Maybe help somewhere else.',
          ['/look_around']
        )
      end

      def zigulenki(response)
        REDIS.set(response.user.name, 'win')
        DB[:score_board].insert(player: response.user.name, time: time_left(response), status: 'win', additions: 'Zigulenki')
        robot.chat_service.send_keyboard(
          response.message.source,
          'Bandera portrait winks and makes the photo. The door opens. Freedom, for a photo in social networks. Zashkvar',
          ['/results']
        )
      end
    end
  end
end

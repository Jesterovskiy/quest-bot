module Lita::Handlers
  module Actions
    module RightWall
      def go_to_right_wall(response)
        robot.chat_service.send_keyboard(
          response.message.source,
          'You see portrait of very familiar guy. With beard. He smiling and you see sun over the right shoulder',
          ['/say_dota_sucks', '/try_open_portrait', '/look_around']
        )
      end

      def say_dota_sucks(response)
        robot.chat_service.send_keyboard(
          response.message.source,
          'You hear "Nahoy poshel, sukablad!". Door is still closed. Zrada.',
          ['/try_open_portrait', '/look_around']
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
          'Portrait winks and makes the photo. The door opens. Freedom, for a photo in social networks. Zashkvar and presents',
          ['/presents']
        )
      end
    end
  end
end

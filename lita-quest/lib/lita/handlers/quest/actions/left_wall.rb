module Lita::Handlers
  module Actions
    module LeftWall
      def go_to_left_wall(response)
        robot.chat_service.send_keyboard(
          response.message.source,
          'On the table you see two discharged phones. Only one plug. Choose Iphone or Android.',
          ['/iphone', '/android', '/look_around']
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
        DB[:score_board].insert(player: response.user.name, time: time_left(response), status: 'lose', additions: 'He did not know the German')
        robot.chat_service.send_keyboard(
          response.message.source,
          'You hear siren and countdown of self-destruction. Bye-bye. And dont forget your presents',
          ['/presents']
        )
      end

      def escape(response)
        REDIS.set(response.user.name, 'win')
        DB[:score_board].insert(player: response.user.name, time: time_left(response), status: 'win', additions: 'Glückwünsche!')
        response.reply()
        robot.chat_service.send_keyboard(
          response.message.source,
          'You run right application, that open door. You free! You win some presents',
          ['/presents']
        )
      end

      def pin_fail(response)
        robot.chat_service.send_keyboard(
          response.message.source,
          'You used last try and Iphone is locked. Try to look around',
          ['/look_around']
        )
      end

      def android(response)
        REDIS.set(response.user.name, 'game_over')
        DB[:score_board].insert(player: response.user.name, time: time_left(response), status: 'lose', additions: 'Wrong phone')
        robot.chat_service.send_keyboard(
          response.message.source,
          'Wrong. You plug Samsung Galaxy Note 7, he ignited, burning the entire room. You dead. Samsung company wery sorry and give you some presents',
          ['/presents']
        )
      end
    end
  end
end

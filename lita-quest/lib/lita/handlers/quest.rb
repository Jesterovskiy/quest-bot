require 'pry'

module Lita
  module Handlers
    class Quest < Handler
      on :connected, :greet
      on :disconnected, :bye
      route(/^test/, :test, command: true, help: { 'admin test' => 'Admin test' })
      route(/^start/, :start, command: true, help: { 'admin test' => 'Admin test' })
      route(/^stop/, :stop, command: true, help: { 'admin test' => 'Admin test' })

      route(/^look_around/, :look_around, command: true, help: { 'admin test' => 'Admin test' })
      route(/^go_ahead/, :go_ahead, command: true, help: { 'admin test' => 'Admin test' })

      def greet(response)
        response.reply('Hello!')
      end

      def bye(response)
        response.reply('See you later =)')
      end

      def test(response)
        response.reply('Test')
      end

      def start(response)
        response.reply("Hello #{response.user.name}. You don't know me. But, I know you. I want to play a game.")
        response.reply("Look around #{response.user.name}. You have 5 minutes to escape room. Better hurry up.")
        sleep 2
        robot.chat_service.send_keyboard(response.message.source, 'The clock starts ticking. Now.', '/look_around' => 'Look around', '/go_ahead' => ' Go ahead')
      end

      def stop
        response.reply('You lose. Game Over. Bye.')
      end

      def look_around
        response.reply('Look around')
      end

      def go_ahead
        response.reply('Go ahead')
      end
    end

    Lita.register_handler(Quest)
  end
end

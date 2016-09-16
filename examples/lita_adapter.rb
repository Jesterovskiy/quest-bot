module Lita
  module Adapters
    class Telegram < Adapter
      attr_reader :client

      config :telegram_token, type: String, required: true

      def initialize(robot)
        super
        @client = ::Telegram::Bot::Client.new(config.telegram_token, logger: ::Logger.new($stdout))
      end

      def chat_service
        ChatService.new(@client)
      end

      def run
        client.listen do |message|
          user = Lita::User.find_by_name(message.from.username)
          user = Lita::User.create(
            message.from.id,
            name: message.from.username,
            first_name: message.from.first_name,
            last_name: message.from.last_name
          ) unless user

          chat = Lita::Room.new(message.chat.id)
          source = Lita::Source.new(user: user, room: chat)

          message.text ||= ''
          msg = Lita::Message.new(robot, message.text, source)

          robot.receive(msg)
        end
      end

      def send_messages(target, messages)
        messages.each do |message|
          client.api.sendChatAction(chat_id: target.room.to_i, action: 'typing')
          sleep 2
          client.api.sendMessage(chat_id: target.room.to_i, text: message, parse_mode: 'Markdown')
        end
      end

      def shut_down
        log.info 'Shutting Down...'
        robot.trigger(:disconnected)
      end

      Lita.register_adapter(:telegram, self)
    end
  end
end

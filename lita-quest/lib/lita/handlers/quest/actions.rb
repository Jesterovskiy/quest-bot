module Lita::Handlers
  module Actions
    include BaseActions, Chairs, LeftWall, RightWall
    attr_accessor :pin_tryes
    EXCLUDE_METHODS = [:results, :restart, :check_timer, :check_game_over, :time_left, :presents].freeze

    def self.before(*names)
      names.each do |name|
        m = instance_method(name)
        define_method(name) do |*args, &block|
          yield(args.first)
          m.bind(self).call(*args, &block)
        end
      end
    end

    before(*instance_methods - EXCLUDE_METHODS) do |response|
      case REDIS.get(response.user.name)
      when 'win'
        return response.reply('You win. Check `/presents`')
      when 'game_over'
        response.reply('You had only one attempt. Bye.')
        return response.reply('Just kidding. Get your `/presents` boy')
      end
    end
  end
end

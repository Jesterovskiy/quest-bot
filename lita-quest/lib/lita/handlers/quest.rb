module Lita
  module Handlers
    class Quest < Handler
      include Actions

      route(/^start/, :start, command: true)
      route(/^finish/, :finish, command: true)
      route(/^results/, :results, command: true)

      route(/^look_around/, :look_around, command: true)
      route(/^go_to_chairs/, :go_to_chairs, command: true)
      route(/^go_to_left_wall/, :go_to_left_wall, command: true)
      route(/^go_to_right_wall/, :go_to_right_wall, command: true)
    end

    Lita.register_handler(Quest)
  end
end

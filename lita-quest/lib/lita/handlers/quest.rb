module Lita
  module Handlers
    class Quest < Handler
      include Actions

      route(/^start/, :start, command: true)
      route(/^restart/, :restart, command: true)
      route(/^results/, :results, command: true)

      route(/^look_around/, :look_around, command: true)

      route(/^go_to_chairs/, :go_to_chairs, command: true)
      route(/^sit_on_left/, :sit_on_left, command: true)
      route(/^yes_please/, :yes_please, command: true)
      route(/^sit_on_right/, :sit_on_right, command: true)
      route(/^use_saw/, :use_saw, command: true)

      route(/^go_to_left_wall/, :go_to_left_wall, command: true)
      route(/^iphone/, :iphone, command: true)
      route(/^android/, :android, command: true)
      route(/^0000/, :pin_0000, command: true)
      route(/^1111/, :pin_1111, command: true)
      route(/^1234/, :pin_1234, command: true)
      route(/^4321/, :pin_4321, command: true)
      route(/^1488/, :pin_1488, command: true)
      route(/^deutschlandlied/, :anthem, command: true)
      route(/^selbstzerstörung/, :self_destruction, command: true)
      route(/^entfliehen/, :escape, command: true)
      route(/^try_another_app/, :pin_1488, command: true)

      route(/^go_to_right_wall/, :go_to_right_wall, command: true)
      route(/^say_slava_ukraine/, :say_slava_ukraine, command: true)
      route(/^try_open_portrait/, :try_open_portrait, command: true)
      route(/^o\//, :zigulenki, command: true)
      route(/^sieg_heil/, :zigulenki, command: true)
    end

    Lita.register_handler(Quest)
  end
end

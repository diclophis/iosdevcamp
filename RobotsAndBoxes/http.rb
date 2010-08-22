#!/usr/bin/env ruby

require 'boot'

$connections = [] 
$simulation_time = 0
$last_command = nil
$sounds = {} 
$play = false
$grid = Grid.new
$audio = []

8.times { |i|
  $audio << File.open("public/bipbop/fifth/boom#{i}.mp3").read
}

EventMachine.run {
  EventMachine.error_handler { |e|
    puts e.inspect
    puts e.backtrace.join("\n")
    puts "Exiting..."
    exit
  }

  timer = EventMachine.add_periodic_timer(TICK_FPS) {
    $simulation_time += TICK_FPS

    if $play
      $play = false
      $grid.sets.each { |player|
        if player.connection.stream
          player.connection.play(player.sound)
        end
      }
    end
  }

  server = EventMachine.start_server(HOST, PORT, QuicktimeConnection) { |connection|
    $connections << connection
  }
  
  console = EventMachine.start_server(HOST, PORT + 1, Linkage)

}
 

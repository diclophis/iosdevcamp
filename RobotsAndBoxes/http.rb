#!/usr/bin/env ruby

require 'boot'

$connections = [] 
$simulation_time = 0
$last_command = nil
$sounds = []
$play = false

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
    if $last_command
      begin
        if $last_command.length > 0
          eval($last_command)
        else
          $play = true
        end
        $last_command = nil
      rescue => problem
        puts problem.inspect
      end
    end

    if $play
      $play = false
      $connections.each_with_index { |connection, index|
        if connection.stream
          sound = $sounds[index]
          if sound
            connection.play(sound)
          else
            #connection.play(0)
          end
        end
      }
    end
    #$sounds = [];
  }

  server = EventMachine.start_server(HOST, PORT, QuicktimeConnection) { |connection|
    $connections << connection
  }
  
  console = EventMachine.start_server(HOST, PORT + 1, Linkage)

}
 

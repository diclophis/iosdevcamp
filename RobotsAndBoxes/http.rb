#!/usr/bin/env ruby

require 'boot'

$connections = [] 
$simulation_time = 0
$last_command = nil
$sounds = []

$audio = []
9.times { |i|
  $audio << File.open("public/bipbop/third/fileSequence#{i}.ts").read
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
        eval($last_command)
        $last_command = nil
      rescue => problem
        puts problem.inspect
      end
    end
    $connections.each_with_index { |connection, index|
      sound = $sounds[index]
      connection.play(sound) if connection.stream && sound
    }
    $sounds = []
  }

  server = EventMachine.start_server(HOST, PORT, QuicktimeConnection) { |connection|
    $connections << connection
  }
  
  console = EventMachine.start_server(HOST, PORT + 1, Linkage)

}
 

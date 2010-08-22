#!/usr/bin/env ruby

require 'boot'

$connections = {} 

EventMachine.run {
  EventMachine.error_handler { |e|
    puts e.inspect
    puts e.backtrace.join("\n")
    puts "Exiting..."
    exit
  }

  @dt = 1.0 / 120.0
  @substeps = 6
  @simulation_time = 0.0

  # Create our Space and set its damping
  # A damping of 0.8 causes the ship bleed off its force and torque over time
  # This is not realistic behavior in a vacuum of space, but it gives the game
  # the feel I'd like in this situation
  @space = CP::Space.new
  @space.damping = 0.8    

  @body = CP::Body.new(100.0, 150.0)
  # In order to create a shape, we must first define it
  # Chipmunk defines 3 types of Shapes: Segments, Circles and Polys
  # We'll use s simple, 4 sided Poly for our Player (ship)
  # You need to define the vectors so that the "top" of the Shape is towards 0 radians (the right)
  shape_array = [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
  @shape = CP::Shape::Poly.new(@body, shape_array, CP::Vec2.new(0,0))
  
  # The collision_type of a shape allows us to set up special collision behavior
  # based on these types.  The actual value for the collision_type is arbitrary
  # and, as long as it is consistent, will work for us; of course, it helps to have it make sense
  #shape.collision_type = :ship
  
  @space.add_body(@body)
  @space.add_shape(@shape)

  @body_2 = CP::Body.new(100.0, 150.0)
  shape_array_2 = [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
  @shape_2 = CP::Shape::Poly.new(@body_2, shape_array_2, CP::Vec2.new(0, 0))
  
  @space.add_body(@body_2)
  @space.add_shape(@shape_2)

  @shape.body.p = CP::Vec2.new(-60, 0)
  @shape_2.body.p = CP::Vec2.new(60, 0)

  game_timer = EventMachine.add_periodic_timer(FPS) {
    @simulation_time += FPS

    if (@simulation_time % 5.0) < 0.5
      @shape.body.p = CP::Vec2.new(-60, 0)
      @shape_2.body.p = CP::Vec2.new(60, 0)
    end

    @shape.body.apply_impulse(CP::Vec2.new(1500.0, 0.0), CP::Vec2.new(0.0, 0.0))
    @shape_2.body.apply_impulse(CP::Vec2.new(-2000.0, 0.0), CP::Vec2.new(0.0, 0.0))

    @substeps.times {
      @space.step(@dt)
    }
    
    p = @body.p
    p_2 = @body_2.p

    $connections.each { |linkage, player|
      line = [p.x, p.y, p_2.x, p_2.y].join(" ")
      puts line
      linkage.send_line(line)
    }
  }

  game_server = EventMachine.start_server(HOST, PORT, Linkage)

}
 

#!/usr/bin/env ruby

X = 8

class Player < Struct.new(:id, :latitude, :longitude, :connection, :sound); end

class Player
  def to_json(*a)
    [self.id, self.sound].to_json(*a)
  end
end

class Grid
  attr_accessor :sets
  
  def initialize
    @sets ||= []
  end
  
  def add(item)
    sets << item unless sets.include?(item)
    sets.sort{|x,y| x.latitude <=> y.latitude && x.longitude <=> y.longitude}
  end
  
  def export
    ((sets.size / X) + 1).times do |i|
      puts sets.slice(i * X,X).inspect
    end
  end
  
  def at(x,y)
    twod = []
    # transform the single-dimensional array into a 2-d array
    ((sets.size / X) + 1).times do |i|
      twod << sets.slice(i * X, X) #.collect(&:id)
    end
    return(twod[x][y])
  end

  def to_json(*a)
    @sets.to_json(*a)
  end
  
end

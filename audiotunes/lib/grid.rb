#!/usr/bin/env ruby

X = 8

class Player < Struct.new(:id, :lat, :lon); end

class Grid
  attr_accessor :sets
  
  def initialize
    @sets ||= []
  end
  
  def add(item)
    sets << item unless sets.include?(item)
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
    return( twod[x][y] )
  end
  
end

#!/usr/bin/env ruby

CP_PATHS = "vendor"

require 'eventmachine'
require 'nokogiri'
require 'linkage'
require 'player'
require 'ffi'
require 'nice-ffi'
require 'chipmunk-ffi'

HOST = "127.0.0.1"
PORT = 10101
FPS = 1.0 / 15.0

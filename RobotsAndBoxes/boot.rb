#!/usr/bin/env ruby



CP_PATHS = "vendor"

require 'eventmachine'
require 'nokogiri'
require 'linkage'
require 'quicktime_connection'
require 'ffi'
require 'nice-ffi'
require 'chipmunk-ffi'
require 'eventmachine_httpserver'
require 'evma_httpserver/response'
require 'json'
require '../audiotunes/lib/grid.rb'


HOST = "0.0.0.0"
PORT = 10101
TICK_FPS = 1.0 / 15.0
WAIT_FPS = 1.0 / 15.0

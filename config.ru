#!/usr/bin/env rackup
# encoding: utf-8

$stdout.sync = true

require './site'
use Rack::Deflater
run Sinatra::Application

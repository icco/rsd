#!/usr/bin/env rackup
# encoding: utf-8

$stdout.sync = true

require './site'
run Sinatra::Application

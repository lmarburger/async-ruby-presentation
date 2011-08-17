require 'rubygems'
require 'bundler'
Bundler.setup :default, :test

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/spec'
require 'wrong/adapters/minitest'

require 'support/vcr'

# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/'
require "saucelabs.rb"

currentDir = File.dirname(__FILE__)
Dir.glob( currentDir+"pc/*.rb"){|f|
  next if (%r|/_|=~f)
  require f
}

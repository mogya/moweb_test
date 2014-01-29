#!/usr/bin/env ruby 
# -*- encoding: utf-8 -*-
require "rubygems"
require "selenium-webdriver"
require "test/unit"

# output T/F as Green/Red
ENV['RSPEC_COLOR'] = 'true'

require File.join(File.expand_path(File.dirname(__FILE__)),  "web_pc.rb")
require File.join(File.expand_path(File.dirname(__FILE__)),  "web_iphone.rb")
require File.join(File.expand_path(File.dirname(__FILE__)),  "web_mobile.rb")

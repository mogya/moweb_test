#!/usr/bin/env ruby 
# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/'
# output T/F as Green/Red
ENV['RSPEC_COLOR'] = 'true'

require File.join(File.expand_path(File.dirname(__FILE__)),  "web_pc.rb")
# require File.join(File.expand_path(File.dirname(__FILE__)),  "web_iphone.rb")
# require File.join(File.expand_path(File.dirname(__FILE__)),  "web_mobile.rb")

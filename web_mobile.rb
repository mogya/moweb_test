# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/'

currentDir = File.dirname(__FILE__)
Dir.glob( currentDir+"/mobile/*.rb"){|f|
  next if (%r|/_|=~f)
  require f
}

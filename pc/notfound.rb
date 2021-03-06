# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)+'/../'
require "saucelabs.rb"

class Notfound < SaucelabsTestCasePC
	def test_notfound
    create_browser('notfound '+__FILE__)
		@browser.get(@base_url + "/")
		@browser.find_element(:id, "input_keyword").clear
		@browser.find_element(:id, "input_keyword").send_keys "そんな名前の駅などないのに"
		@browser.find_element(:id, "keyword_submit").click
    wait_until(/^[\s\S]*Error[\s\S]*$/){ @browser.title }
		assert_match(/^[\s\S]*Error[\s\S]*$/, @browser.title)
	end
end

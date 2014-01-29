require "rubygems"
require "selenium-webdriver"
require "test/unit"

class Search1 < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://oasis.mogya.com/"
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_search1
    @driver.get(@base_url + "/mobile/")
    @driver.find_element(:id, "input_station").clear
    @driver.find_element(:id, "input_station").send_keys "いわき駅"
    @driver.find_element(:css, "#searchform input[type=\"submit\"]").click
    assert element_present?(:css, "#searchform input[value=\"いわき駅(JR常磐線)\"]")
    @driver.find_element(:css, "#searchform input[type=\"submit\"]").click
    assert_match /^[\s\S]*いわき駅[\s\S]*$/, @driver.title
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
end

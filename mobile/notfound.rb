require "selenium-webdriver"
require "test/unit"

class Notfound < Test::Unit::TestCase

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
  
  def test_notfound
    @driver.get(@base_url + "/mobile/")
    @driver.find_element(:id, "input_station").clear
    @driver.find_element(:id, "input_station").send_keys "そんな名前の駅などないのに"
    @driver.find_element(:css, "#searchform input[type=\"submit\"]").click
    # ERROR: Caught exception [ERROR: Unsupported command [isTextPresent]]
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

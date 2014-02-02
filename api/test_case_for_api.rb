require "./saucelabs.rb"
require 'net/http'
require 'json'

class TestCaseForAPI < Test::Unit::TestCase
  def initialize *args
    super
    @base_url = "http://oasis.mogya.com/api/"
    @develop_mode = (ENV["develop"] && false!=ENV["develop"].downcase)
    @base_url = "http://oasis.mogya.com/api2/" if @develop_mode
  end
  def get(url)
    uri = URI.parse(url)
    req_url = "#{uri.path}"
    req_url += "?#{uri.query}" unless uri.query.nil?
    req = Net::HTTP::Get.new(req_url)
    res = Net::HTTP.start(uri.host, uri.port) {|http|
      http.request(req)
    }
    res
  end
  def getHTML(url)
    get(url).body
  end
  def getJSON(url)
    JSON.parse( getHTML(url),{symbolize_names:true} )
  end
end

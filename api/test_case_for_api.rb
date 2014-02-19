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

  def debug *args
    buf = ''
    args.each{|arg|
      if arg.kind_of?(String)
        buf = buf + arg
      else
        buf = buf + arg.to_json + "\n"
      end
    }
    STDERR.puts buf
  end

  # webページオブジェクトを取得する
  # params:hash OR String
  # params(String):取得するURL
  # params[:url]:取得するURL
  # params[:username]:BASIC認証のユーザー名
  # params[:password]:BASIC認証のパスワード
  def get(params)
    # 引数としてurlのみを渡すことも許容
    params = {url:params} if params.kind_of? String
    uri = URI.parse(params[:url])
    req_url = "#{uri.path}"
    req_url += "?#{uri.query}" unless uri.query.nil?
    # debug "url:#{req_url}"
    req = Net::HTTP::Get.new(req_url)
    req.basic_auth params[:username],params[:password] if (params[:username]&&params[:password])
    res = Net::HTTP.start(uri.host, uri.port) {|http|
      http.request(req)
    }
    res
  end
  # webページを取得して、HTMLソースを文字列として返す
  def getHTML(params)
    get(params).body
  end
  # webページを取得してJSONオブジェクトとして返す
  def getJSON(params)
    JSON.parse( getHTML(params),{symbolize_names:true} )
  end
end

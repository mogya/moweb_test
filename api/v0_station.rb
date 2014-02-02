# -*- encoding: utf-8 -*-
require "./api/test_case_for_api.rb"

class V0_station < TestCaseForAPI
  def test_station1
    params = {name:'湯瀬温泉'}
    json = getJSON( "#{@base_url}v0/station?#{ URI.encode_www_form(params) }" )
    assert_match 'OK', json[:status], "status check"
    station = json[:results][0]
    assert_match /湯瀬温泉/, station[:name], "name match"
    assert_match /ゆぜおんせん/, station[:kana], "kana match"
    assert_match /JR花輪線/, station[:line], "line match"
    assert_match /秋田県鹿角市/, station[:area], "area match"
    assert station[:lat].to_f<50 , "lat check"
    assert station[:lat].to_f>30 , "lat check"
    assert station[:lng].to_f<150 , "lng check"
    assert station[:lng].to_f>120 , "lng check"
  end
  def test_station2
    params = {area:'秋田県'}
    json = getJSON( "#{@base_url}v0/station?#{ URI.encode_www_form(params) }" )
    assert_match 'OK', json[:status], "status check"
    station = json[:results].find{|station|
    	/湯瀬温泉/ === station[:name]
    }
    assert_match /湯瀬温泉/, station[:name], "name match"
    assert_match /ゆぜおんせん/, station[:kana], "kana match"
    assert_match /JR花輪線/, station[:line], "line match"
    assert_match /秋田県鹿角市/, station[:area], "area match"
    assert station[:lat].to_f<50 , "lat check"
    assert station[:lat].to_f>30 , "lat check"
    assert station[:lng].to_f<150 , "lng check"
    assert station[:lng].to_f>120 , "lng check"
  end
end

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
    assert station[:latitude].to_f<50 , "lat check"
    assert station[:latitude].to_f>30 , "lat check"
    assert station[:longitude].to_f<150 , "lng check"
    assert station[:longitude].to_f>120 , "lng check"
  end
  def test_station_area
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
    assert station[:latitude].to_f<50 , "lat check"
    assert station[:latitude].to_f>30 , "lat check"
    assert station[:longitude].to_f<150 , "lng check"
    assert station[:longitude].to_f>120 , "lng check"
  end
  def test_station_name
    params = {name:'湯瀬温泉'}
    json = getJSON( "#{@base_url}v0/station?#{ URI.encode_www_form(params) }" )
    assert_match 'OK', json[:status], "status check"
    station = json[:results][0]
    assert_match /湯瀬温泉/, station[:name], "name match"
    assert_match /ゆぜおんせん/, station[:kana], "kana match"
    assert_match /JR花輪線/, station[:line], "line match"
    assert_match /秋田県鹿角市/, station[:area], "area match"
    assert station[:latitude].to_f<50 , "lat check"
    assert station[:latitude].to_f>30 , "lat check"
    assert station[:longitude].to_f<150 , "lng check"
    assert station[:longitude].to_f>120 , "lng check"
  end
  def test_station_order
    params = {name:'福島',order:'latitude'}
    json = getJSON( "#{@base_url}v0/station?#{ URI.encode_www_form(params) }" )
    assert_match 'OK', json[:status], "status check"
    _lat = 0.0
    json[:results].each{|station|
        assert_compare station[:latitude].to_f, '>=' , _lat, 'station.lat should be sorted.'
        _lat = station[:latitude].to_f
    }

    params = {name:'福島',order:'longitude'}
    json = getJSON( "#{@base_url}v0/station?#{ URI.encode_www_form(params) }" )
    assert_match 'OK', json[:status], "status check"
    _lng = 0.0
    json[:results].each{|station|
        assert(station[:longitude].to_f>=_lat, 'station.lng should be sorted.')
        _lat = station[:longitude].to_f
    }

  end
end

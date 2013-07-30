require 'spec_helper'

class StubResponse < Net::HTTPOK
  def initialize(httpv, code, msg, body)
    super(httpv, code, msg)
    @body = body
  end
  
  def body
    @body
  end
end

describe Earthquake do
  before :each do
    Earthquake.delete_all
  end
  
  it 'should store all data initially by ::ingest_from_url' do
    stubbed_body = "Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region\r\n" +
    "nc,72035200,1,\"Sunday, July 28, 2013 00:18:30 UTC\",35.5513,-120.7835,2.6,4.60,73,\"Central California\"\r\n" +
    "nn,00418867,1,\"Saturday, July 27, 2013 23:53:54 UTC\",38.9352,-118.8163,1.1,17.80, 7,\"Nevada\"\r\n"
    
    Net::HTTP.stub(:get_response).and_return(StubResponse.new('1.1', '200', 'OK', stubbed_body))
    result = Earthquake.ingest_from_url('http://earthquake.usgs.gov/stubbed_content.txt')
    result.should be_true
    
    stored_data = Earthquake.all
    stored_data.size.should == 2
    
    geo_factory = RGeo::Geographic.spherical_factory(srid: 4326)
    
    expected_records = [
      ['nc', '72035200', 'Central California', Time.at(1374970710).utc, 2.6, 4.6, 73, geo_factory.point(-120.7835, 35.5513)],
      ['nn', '00418867', 'Nevada', Time.at(1374969234).utc, 1.1, 17.8, 7, geo_factory.point(-118.8163, 38.9352)]
    ]
    
    stored_data.each_with_index do |r, n|
      [r.source, r.eqid, r.region, r.occurred_at, r.magnitude, r.depth, r.number_of_stations_reported, r.location].should == expected_records[n]
    end
  end
  
  it 'should append new data by ::ingest_from_url' do
    stubbed_body = "Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region\r\n" +
      "nc,72035290,0,\"Sunday, July 28, 2013 04:39:44 UTC\",38.7922,-122.8083,1.0,3.70,18,\"Northern California\"\r\n" +
      "nc,72035285,0,\"Sunday, July 28, 2013 04:09:26 UTC\",36.6508,-121.2683,1.0,8.90, 6,\"Central California\"\r\n" +
      "nc,72035275,0,\"Sunday, July 28, 2013 04:01:34 UTC\",37.6718,-119.0092,1.1,0.20, 5,\"Long Valley area, California\"\r\n"

    Earthquake.parse_csv(stubbed_body)

    stored_data = Earthquake.all
    stored_data.size.should == 3
    
    expected_unique_ids = [['nc', '72035290'], ['nc', '72035285'], ['nc', '72035275']]
    stored_data.each_with_index do |r, n|
      [r.source, r.eqid].should == expected_unique_ids[n]
    end

    stubbed_new_body = "Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region\r\n" +
      "ci,11340418,2,\"Sunday, July 28, 2013 05:00:10 UTC\",34.0115,-117.1838,1.0,7.70,18,\"Greater Los Angeles area, California\"\r\n" +
      "ak,10768318,1,\"Sunday, July 28, 2013 04:43:32 UTC\",60.1361,-141.4384,1.8,0.60,13,\"Southern Alaska\"\r\n" +
      "nc,72035290,0,\"Sunday, July 28, 2013 04:39:44 UTC\",38.7922,-122.8083,1.0,3.70,18,\"Northern California\"\r\n" +
      "nc,72035285,0,\"Sunday, July 28, 2013 04:09:26 UTC\",36.6508,-121.2683,1.0,8.90, 6,\"Central California\"\r\n" +
      "nc,72035275,0,\"Sunday, July 28, 2013 04:01:34 UTC\",37.6718,-119.0092,1.1,0.20, 5,\"Long Valley area, California\"\r\n"

    Net::HTTP.stub(:get_response).and_return(StubResponse.new('1.1', '200', 'OK', stubbed_new_body))
    Earthquake.ingest_from_url('http://earthquake.usgs.gov/stubbed_content.txt')

    stored_data = Earthquake.all
    stored_data.size.should == 5

    expected_new_unique_ids = [['nc', '72035290'], ['nc', '72035285'], ['nc', '72035275'], ['ci', '11340418'], ['ak', '10768318']]
    stored_data.each_with_index do |r, n|
      [r.source, r.eqid].should == expected_new_unique_ids[n]
    end
  end
end


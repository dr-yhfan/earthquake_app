require 'spec_helper'
require 'rake'

class StubResponse < Net::HTTPOK
  def initialize(httpv, code, msg, body)
    super(httpv, code, msg)
    @body = body
  end
  
  def body
    @body
  end
end

describe 'usgs rake tasks' do
  before :all do
    EarthquakeApp::Application.load_tasks
    @rake = Rake::Task
  end

  describe 'rake usgs:earthquakes:ingest' do
    before :all do
      Earthquake.delete_all
      @task_name = 'usgs:earthquakes:ingest'
    end
    
    before :each do
      Earthquake.delete_all
    end
    
    it "should have 'environment'" do
      @rake[@task_name].prerequisites.should include("environment")
    end
    
    it 'should ingest data' do
      Earthquake.all.size.should == 0
      
      stubbed_body = "Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region\r\n" +
      "nc,72035200,1,\"Sunday, July 28, 2013 00:18:30 UTC\",35.5513,-120.7835,2.6,4.60,73,\"Central California\"\r\n" +
      "nn,00418867,1,\"Saturday, July 27, 2013 23:53:54 UTC\",38.9352,-118.8163,1.1,17.80, 7,\"Nevada\"\r\n"

      Net::HTTP.stub(:get_response).and_return(StubResponse.new('1.1', '200', 'OK', stubbed_body))
      
      @rake[@task_name].execute
      Earthquake.all.size.should == 2
    end
    
    it 'should ingest additional data' do
      Earthquake.all.size.should == 0
      
      stubbed_body = "Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region\r\n" +
        "nc,72035290,0,\"Sunday, July 28, 2013 04:39:44 UTC\",38.7922,-122.8083,1.0,3.70,18,\"Northern California\"\r\n" +
        "nc,72035285,0,\"Sunday, July 28, 2013 04:09:26 UTC\",36.6508,-121.2683,1.0,8.90, 6,\"Central California\"\r\n" +
        "nc,72035275,0,\"Sunday, July 28, 2013 04:01:34 UTC\",37.6718,-119.0092,1.1,0.20, 5,\"Long Valley area, California\"\r\n"
      Net::HTTP.stub(:get_response).and_return(StubResponse.new('1.1', '200', 'OK', stubbed_body))      
      @rake[@task_name].execute
      Earthquake.all.size.should == 3
      
      stubbed_new_body = "Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region\r\n" +
        "ci,11340418,2,\"Sunday, July 28, 2013 05:00:10 UTC\",34.0115,-117.1838,1.0,7.70,18,\"Greater Los Angeles area, California\"\r\n" +
        "ak,10768318,1,\"Sunday, July 28, 2013 04:43:32 UTC\",60.1361,-141.4384,1.8,0.60,13,\"Southern Alaska\"\r\n" +
        "nc,72035290,0,\"Sunday, July 28, 2013 04:39:44 UTC\",38.7922,-122.8083,1.0,3.70,18,\"Northern California\"\r\n" +
        "nc,72035285,0,\"Sunday, July 28, 2013 04:09:26 UTC\",36.6508,-121.2683,1.0,8.90, 6,\"Central California\"\r\n" +
        "nc,72035275,0,\"Sunday, July 28, 2013 04:01:34 UTC\",37.6718,-119.0092,1.1,0.20, 5,\"Long Valley area, California\"\r\n"
    
      Net::HTTP.stub(:get_response).and_return(StubResponse.new('1.1', '200', 'OK', stubbed_new_body))
    
      @rake[@task_name].execute
      Earthquake.all.size.should == 5
    end
  end
end

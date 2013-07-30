require 'spec_helper'
require 'spec_earthquake_helper'

describe EarthquakesController do
  include SpecEarthquakeHelper
  
  before :all do
    clear_earthquakes
    populate_earthquakes
    @essential_fields = ["source", "eqid", "version", "occurred_at", "magnitude", "depth", "number_of_stations_reported", "region", "location"]
  end
  
  after :all do
    clear_earthquakes
  end
    
  describe 'GET #earthquakes.json' do
    context 'with no parameter' do
      it 'should get all earthquakes' do
        do_test(nil, all_data_array)
      end
    end
    
    context 'with a single parameter' do
      it 'should get only earthquakes after the time specified by the "since" parameter' do
        do_test([[:since, '1374966000']], since_data_array)
      end
      
      it 'should get only earthquakes on the day specified by the "on" parameter' do
        do_test([[:on, '1374966000']], on_data_array)
      end
      
      it 'should get only earthquakes greater than the magnitude specified by the "over" parameter' do
        do_test([[:over, '4.0']], over_data_array)
      end
      
      it 'should get only earthquakes within the 5-mile radius of the lat/lon location specified by the "near" parameter' do
        do_test([[:near, '33.98,-117.15']], near_data_array)
      end
    end
    
    context 'with all parameters' do
      it 'should get only earthquakes filtered by all parameters' do
        do_test([[:since, '1374886800'], [:on, '1374886800'], [:over, '1.2'], [:near, '33.98,-117.15']], all_parameters_data_array)
      end
    end
  end
  
end

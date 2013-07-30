require 'csv'

class Earthquake < ActiveRecord::Base
  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(srid: 4326))
  
  scope :latest_record, lambda { order(:occurred_at).last }
  scope :all_ordered, lambda { order('occurred_at desc') }
  scope :since_time_until_day_of, lambda {|since_epoch_time, on_epoch_time|
          # At least one of two arguments has to be present.
          if since_epoch_time.blank? and on_epoch_time.blank?
            nil
          else
            from_time = nil
            to_time = nil
            if since_epoch_time.present?
              from_time = Time.at(since_epoch_time.to_i).utc
            end
            if on_epoch_time.present?
              the_end_time = Time.at(on_epoch_time.to_i).utc
              the_end_day = Time.utc(the_end_time.year, the_end_time.month, the_end_time.day)
              to_time = the_end_day + 1.day
              if from_time.blank?
                from_time = the_end_day
              end
            end
            if to_time.blank?
              to_time = Time.now.utc + 1.minute  # Just to make sure 'now' is covered.
            end
            where('occurred_at >= ? AND occurred_at < ?', from_time, to_time).order('occurred_at desc')
          end
        }
  scope :over_magnitude, lambda {|magnitude| where('magnitude > ?', magnitude.to_f).order('occurred_at desc')}
  scope :near_lat_lon, lambda {|lat_lon_string, radius=8046.72|
          # Default radius of 5 miles is about 8046.72 meters.
          lat,lon = lat_lon_string.split(',')
          where("ST_Distance(location, 'POINT(? ?)') <= ?", lon.to_f, lat.to_f, radius)
        }
  
  class << self
    def ingest_from_url(source_url)
      http_response = Net::HTTP.get_response(URI(source_url))
      if http_response.present? and http_response.msg == 'OK'
        parse_csv(http_response.body)
        return true
      end
      return false
    end
    
    def parse_csv(csv_data)
      store_records(CSV.parse(csv_data, {headers: true, return_headers: false}))
    end
    
    protected
    
    def store_records(parsed_records)
      if self.first.blank?
        # There is no record in the table.  We will store everything.
        parsed_records.each do |r|
          create_a_record(r)
        end
      else
        # There are records in the table.  We will add to them.
        our_latest_record = self.latest_record
        parsed_records.each do |r|
          record_time = DateTime.strptime(r['Datetime'], "%A, %B %d, %Y %H:%M:%S %Z")
          if record_time > our_latest_record.occurred_at
            create_a_record(r)
          elsif record_time == our_latest_record.occurred_at
            begin
              unless r['Src'] == our_latest_record.source and r['Eqid'] == our_latest_record.eqid
                create_a_record(r)
              end
            rescue Exception
              # Just ignore the error for possibly storing a duplicate.
              # Unique key index enforces storage of unique records.
            end
          else
            break
          end
        end
      end
    end

    def create_a_record(record)
      self.create({
        source: record['Src'],
        eqid: record['Eqid'],
        version: record['Version'],
        occurred_at: DateTime.strptime(record['Datetime'], "%A, %B %d, %Y %H:%M:%S %Z"),
        magnitude: record['Magnitude'].to_f,
        depth: record['Depth'].to_f,
        number_of_stations_reported: record['NST'].to_i,
        region: record['Region'],
        location: "POINT(#{record['Lon']} #{record['Lat']})"
      })
    end
  end
end

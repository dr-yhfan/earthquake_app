namespace :usgs do
  namespace :earthquakes do
    desc "Ingest earthquake data from USGS"
    task :ingest => :environment do
      Earthquake.ingest_from_url('http://earthquake.usgs.gov/earthquakes/catalogs/eqs7day-M1.txt')
    end
  end
end

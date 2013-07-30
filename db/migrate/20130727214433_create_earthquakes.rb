class CreateEarthquakes < ActiveRecord::Migration
  def change
    create_table :earthquakes do |t|
      t.string :source
      t.string :eqid
      t.string :version
      t.timestamp :occurred_at
      t.float :magnitude
      t.float :depth
      t.integer :number_of_stations_reported
      t.string :region
      t.point :location, geographic: true

      t.timestamps
    end
    
    change_table :earthquakes do |t|
      t.index :occurred_at
      t.index :magnitude
      t.index :location, spatial: true
      t.index :region
      t.index [:source, :eqid], unique: true
    end
  end
end

class CreateAirQualityMetrics < ActiveRecord::Migration[8.0]
  def change
    create_table :air_quality_metrics do |t|
      t.belongs_to :location, null: false, foreign_key: true

      t.decimal :co, precision: 17, scale: 14
      t.decimal :no, precision: 17, scale: 14
      t.decimal :no2, precision: 17, scale: 14
      t.decimal :o3, precision: 17, scale: 14
      t.decimal :so2, precision: 17, scale: 14
      t.decimal :pm2_5, precision: 17, scale: 14
      t.decimal :pm10, precision: 17, scale: 14
      t.decimal :nh3, precision: 17, scale: 14

      t.timestamp :recorded_at, null: false, index: true
      t.timestamps
    end
  end
end

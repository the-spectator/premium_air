class ChangeMetricPrecisionAndScale < ActiveRecord::Migration[8.0]
  def change
    change_table :air_quality_metrics, bulk: true do |t|
      t.change :co,  :decimal, precision: 17, scale: 6
      t.change :no,  :decimal, precision: 17, scale: 6
      t.change :no2, :decimal,  precision: 17, scale: 6
      t.change :o3,  :decimal, precision: 17, scale: 6
      t.change :so2, :decimal,  precision: 17, scale: 6
      t.change :pm2_5, :decimal, precision: 17, scale: 6
      t.change :pm10, :decimal, precision: 17, scale: 6
      t.change :nh3, :decimal,  precision: 17, scale: 6
    end
  end
end

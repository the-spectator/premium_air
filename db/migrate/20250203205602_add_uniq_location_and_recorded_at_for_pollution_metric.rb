class AddUniqLocationAndRecordedAtForPollutionMetric < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    remove_index :air_quality_metrics, :recorded_at, algorithm: :concurrently
    add_index :air_quality_metrics, [ :recorded_at, :location_id ], unique: true, algorithm: :concurrently
  end
end

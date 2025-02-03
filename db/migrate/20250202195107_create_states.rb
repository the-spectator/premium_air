class CreateStates < ActiveRecord::Migration[8.0]
  def change
    create_table :states do |t|
      t.string :name, null: false, index: true

      t.timestamps
    end
  end
end

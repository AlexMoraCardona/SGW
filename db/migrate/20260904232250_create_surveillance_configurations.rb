class CreateSurveillanceConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_configurations do |t|
      t.string :name, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :surveillance_configurations, :name, unique: true
    add_index :surveillance_configurations, :status
  end
end

class CreateStandarDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :standar_details do |t|
      t.string :description
      t.decimal :value, default: 0
      t.integer :standar, default: 0

      t.timestamps
    end
  end
end

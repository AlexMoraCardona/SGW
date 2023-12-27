class CreateClasificationDangerDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :clasification_danger_details do |t|
      t.string :name

      t.timestamps
    end
    add_reference :clasification_danger_details, :clasification_danger, null: true, foreign_key: true
  end
end

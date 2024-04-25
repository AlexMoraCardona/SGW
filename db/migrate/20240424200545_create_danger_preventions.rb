class CreateDangerPreventions < ActiveRecord::Migration[7.0]
  def change
    create_table :danger_preventions do |t|
      t.string :name

      t.timestamps
    end
    add_reference :danger_preventions, :clasification_danger_detail, null: true, foreign_key: true
  end
end

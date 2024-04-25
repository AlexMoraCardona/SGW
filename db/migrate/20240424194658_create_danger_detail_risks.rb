class CreateDangerDetailRisks < ActiveRecord::Migration[7.0]
  def change
    create_table :danger_detail_risks do |t|
      t.string :name

      t.timestamps
    end
    add_reference :danger_detail_risks, :clasification_danger_detail, null: true, foreign_key: true
  end
end

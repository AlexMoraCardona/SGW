class CreateOccupationalExamItems < ActiveRecord::Migration[7.0]
  def change
    create_table :occupational_exam_items do |t|
      t.integer :consecutive, default: 0
      t.date :fec_exam
      t.date :fec_venc
      t.integer :exam_type, default: 0
      t.string :nro_identification
      t.string :name
      t.string :post
      t.string :concept
      t.string :addressing
      t.string :recommendations
      t.string :restrictions
      t.string :sve
      t.string :action
      t.string :follow_up

      t.timestamps
    end
    add_reference :occupational_exam_items, :occupational_exam, null: true, foreign_key: true
  end
end

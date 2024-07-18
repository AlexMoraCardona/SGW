class CreateSafetyInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :safety_inspections do |t|
      t.date :date_inspection
      t.string :place_inspection
      t.string :area_inspection
      t.string :productivity_affectation
      t.integer :user_responsible, default: 0
      t.date :date_firm_responsible
      t.integer :firm_responsible, default: 0
      t.string :post_responsible

      t.timestamps
    end
    add_reference :safety_inspections, :entity, null: true, foreign_key: true
  end
end

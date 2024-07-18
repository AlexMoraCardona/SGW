class CreateSituationConditions < ActiveRecord::Migration[7.0]
  def change
    create_table :situation_conditions do |t|
      t.string :name

      t.timestamps
    end
    add_reference :situation_conditions, :type_condition_inspection, null: true, foreign_key: true
  end
end

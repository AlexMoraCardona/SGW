class CreateTypeConditionInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :type_condition_inspections do |t|
      t.string :name

      t.timestamps
    end
  end
end

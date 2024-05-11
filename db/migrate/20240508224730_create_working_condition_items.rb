class CreateWorkingConditionItems < ActiveRecord::Migration[7.0]
  def change
    create_table :working_condition_items do |t|
      t.integer :exposed, default: 0
      t.string :observation

      t.timestamps
    end
    add_reference :working_condition_items, :working_condition, null: true, foreign_key: true
  end
end

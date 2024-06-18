class CreateFormatActions < ActiveRecord::Migration[7.0]
  def change
    create_table :format_actions do |t|
      t.date :date_format
      t.string :description_conformity
      t.string :causes_conformity
      t.string :task
      t.string :activity
      t.string :section
      t.string :type_action
      t.string :description_action
      t.integer :user_responsible, default: 0
      t.string :post_responsible
      t.string :area_responsible
      t.date :date_execution
      t.date :date_verification
      t.string :efficiency_results
      t.integer :action_completed, default: 0
      t.string :observations

      t.timestamps
    end
    add_reference :format_actions, :entity, null: true, foreign_key: true
  end
end

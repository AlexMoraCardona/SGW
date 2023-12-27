class CreateMatrixActionItems < ActiveRecord::Migration[7.0]
  def change
    create_table :matrix_action_items do |t|
      t.integer :consecutive, default: 0
      t.integer :year, default: 1900
      t.integer :type_corrective, default: 0
      t.string :clasification_type_corrective
      t.integer :campus, default: 0
      t.date :date_action_conformity
      t.string :area
      t.string :description_action
      t.integer :action_implement, default: 0
      t.string :responsible
      t.date :commitment_date
      t.date :closet_date
      t.integer :took_actions, default: 0
      t.integer :state_actions, default: 0

      t.timestamps
    end
    add_reference :matrix_action_items, :matrix_corrective_action, null: true, foreign_key: true
  end
end

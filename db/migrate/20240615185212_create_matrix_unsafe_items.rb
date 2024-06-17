class CreateMatrixUnsafeItems < ActiveRecord::Migration[7.0]
  def change
    create_table :matrix_unsafe_items do |t|
      t.date :date_item
      t.integer :user_reporta, default: 0
      t.string :cargo_reporta
      t.string :correo_reporta
      t.string :sede
      t.string :exact_ubication
      t.string :description_usafe
      t.string :solution_usafe
      t.integer :tip_action, default: 0
      t.integer :state_unsafe, default: 0
      t.string :observations
      t.integer :user_recibe, default: 0
      t.date :date_intervencion

      t.timestamps
    end
    add_reference :matrix_unsafe_items, :entity, null: true, foreign_key: true
    add_reference :matrix_unsafe_items, :unsafe_condition, null: true, foreign_key: true
  end
end

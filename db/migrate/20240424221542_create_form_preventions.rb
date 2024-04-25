class CreateFormPreventions < ActiveRecord::Migration[7.0]
  def change
    create_table :form_preventions do |t|
      t.integer :eli, default: 0
      t.integer :sus, default: 0
      t.integer :ci, default: 0
      t.integer :ca, default: 0
      t.integer :epp, default: 0

      t.timestamps
    end
    add_reference :form_preventions, :admin_extent_danger, null: true, foreign_key: true
    add_reference :form_preventions, :user, null: true, foreign_key: true
    add_reference :form_preventions, :danger_prevention, null: true, foreign_key: true
  end
end

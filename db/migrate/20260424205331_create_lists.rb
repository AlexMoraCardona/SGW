class CreateLists < ActiveRecord::Migration[7.0]
  def change
    create_table :lists do |t|
      t.integer :state, default: 0
      t.string :observation

      t.timestamps
    end
    add_reference :lists, :check_list, null: true, foreign_key: true
    add_reference :lists, :check_list_item, null: true, foreign_key: true
    add_reference :lists, :entity, null: true, foreign_key: true
  end
end

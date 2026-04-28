class CreateCheckListItems < ActiveRecord::Migration[7.0]
  def change
    create_table :check_list_items do |t|
      t.string :name
      t.integer :clasification, default: 0
      t.integer :state, default: 0
      t.string :item

      t.timestamps
    end
    add_reference :check_list_items, :check_list, null: true, foreign_key: true
  end
end

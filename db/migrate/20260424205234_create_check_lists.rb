class CreateCheckLists < ActiveRecord::Migration[7.0]
  def change
    create_table :check_lists do |t|
      t.string :name
      t.integer :state, default: 0

      t.timestamps
    end
  end
end

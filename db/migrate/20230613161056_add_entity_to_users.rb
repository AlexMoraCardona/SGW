class AddEntityToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :entity, :integer, default: 0
  end
end

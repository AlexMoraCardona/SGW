class CelToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :cel, :string
    add_column :users, :phone, :string
  end
end

class ClasificationToLists < ActiveRecord::Migration[7.0]
  def change
    add_column :lists, :clasification, :integer, default: 0
  end
end

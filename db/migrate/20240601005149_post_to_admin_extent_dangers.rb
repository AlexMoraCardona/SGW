class PostToAdminExtentDangers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_extent_dangers, :post, :string
  end
end

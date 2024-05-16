class PostToAdmExtinguishers < ActiveRecord::Migration[7.0]
  def change
    add_column :adm_extinguishers, :post, :string
  end
end

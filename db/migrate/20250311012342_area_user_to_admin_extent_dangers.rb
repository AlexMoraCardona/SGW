class AreaUserToAdminExtentDangers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_extent_dangers, :epp, :integer, default: 0
    add_column :admin_extent_dangers, :epp_cuales, :string
    add_column :admin_extent_dangers, :area, :string
    add_column :admin_extent_dangers, :equipment_operates, :string
    add_column :admin_extent_dangers, :control_proposal, :string
  end
end

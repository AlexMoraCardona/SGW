class CualSufferedAccidentToAdminExtentDangers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_extent_dangers, :cual_suffered_accident, :string
  end
end

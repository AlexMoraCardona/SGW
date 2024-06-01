class UserToAdminExtentDangers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_extent_dangers, :firm_user, :integer, default: 0
    add_column :admin_extent_dangers, :date_firm_user, :date
    add_reference :admin_extent_dangers, :user, null: true, foreign_key: true
    remove_column :form_preventions, :user_id, null: true, foreign_key: true
  end
end

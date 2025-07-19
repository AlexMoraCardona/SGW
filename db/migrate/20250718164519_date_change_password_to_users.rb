class DateChangePasswordToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :date_change_password, :date
    add_column :users, :ultima_date_login, :date
    add_column :investigations, :state_investigation, :integer, default: 0
    add_column :investigations, :date_state_investigation, :date
  end
end

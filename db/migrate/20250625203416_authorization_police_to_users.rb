class AuthorizationPoliceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :authorization_police, :integer, default: 0
    add_column :users, :authorization_date, :date
    add_column :users, :license, :string
    add_column :report_officials, :resources_allocated, :integer, default: 0
    add_column :report_officials, :resources_planned, :integer, default: 0
    add_column :report_officials, :per_resources, :decimal, default: 0
    add_column :report_officials, :investigation_total, :integer, default: 0
    add_column :report_officials, :investigation_investigated, :integer, default: 0
    add_column :report_officials, :per_investigation, :decimal, default: 0
  end
end

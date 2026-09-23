class AddReferenceToLessons < ActiveRecord::Migration[7.0]
  def change
    add_column :mock_scripts, :version, :integer, default: 0
    add_column :mock_scripts, :code, :string
    add_column :audit_reports, :version, :integer, default: 0
    add_column :audit_reports, :code, :string
    add_column :profiles, :version, :integer, default: 0
    add_column :profiles, :code, :string
    add_column :simulacrums, :version, :integer, default: 0
    add_column :simulacrums, :code, :string
    add_column :investigations, :version, :integer, default: 0
    add_column :investigations, :code, :string
    add_column :improvement_plans, :version, :integer, default: 0
    add_column :improvement_plans, :code, :string
    add_column :direction_reviews, :version, :integer, default: 0
    add_column :direction_reviews, :code, :string
    add_column :lessons, :version, :integer, default: 0
    add_column :lessons, :code, :string
  end
end

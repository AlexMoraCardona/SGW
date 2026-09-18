class AddReferenceToMatrixConditions < ActiveRecord::Migration[7.0]
  def change
    add_column :matrix_conditions, :version, :integer, default: 0
    add_column :matrix_conditions, :code, :string
    add_column :matrix_goals, :version, :integer, default: 0
    add_column :matrix_goals, :code, :string
    add_column :admin_extent_dangers, :version, :integer, default: 0
    add_column :admin_extent_dangers, :code, :string
    add_column :complaints, :version, :integer, default: 0
    add_column :complaints, :code, :string
    add_column :analysis_risks, :version, :integer, default: 0
    add_column :analysis_risks, :code, :string
    add_column :security_standards, :version, :integer, default: 0
    add_column :security_standards, :code, :string
    add_column :change_managements, :version, :integer, default: 0
    add_column :change_managements, :code, :string
  end
end

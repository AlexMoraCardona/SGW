class AddAsesorExternoToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :external_consultant, :integer, default: 0
    add_column :users, :president_copasst, :integer, default: 0
    add_column :users, :secretary_copasst, :integer, default: 0
    add_column :users, :vigia_sgsst, :integer, default: 0
    add_column :users, :cargo_rol, :string
  end
end

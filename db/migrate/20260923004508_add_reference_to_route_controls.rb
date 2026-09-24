class AddReferenceToRouteControls < ActiveRecord::Migration[7.0]
  def change
    add_column :route_controls, :version, :integer, default: 0
    add_column :route_controls, :code, :string
    add_column :car_checklists, :version, :integer, default: 0
    add_column :car_checklists, :code, :string
    add_column :moto_checklists, :version, :integer, default: 0
    add_column :moto_checklists, :code, :string
    add_column :safety_inspections, :version, :integer, default: 0
    add_column :safety_inspections, :code, :string
    add_column :survey_profiles, :version, :integer, default: 0
    add_column :survey_profiles, :code, :string
    add_column :entities, :monthly_advice, :integer, default: 0

  end
end

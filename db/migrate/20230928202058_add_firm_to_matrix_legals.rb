class AddFirmToMatrixLegals < ActiveRecord::Migration[7.0]
  def change
    add_column :matrix_legals, :date_firm_legal_representative, :date
    add_column :matrix_legals, :date_firm_adviser_sst, :date
    add_column :matrix_legals, :date_firm_responsible_sst, :date
    add_column :matrix_legals, :firm_legal_representative, :integer, default: 0 
    add_column :matrix_legals, :firm_adviser_sst, :integer, default: 0
    add_column :matrix_legals, :firm_responsible_sst, :integer, default: 0
    add_column :matrix_legals, :version, :integer, default: 0
    add_column :matrix_legals, :code, :string

    add_column :matrix_danger_risks, :date_firm_legal_representative, :date
    add_column :matrix_danger_risks, :date_firm_adviser_sst, :date
    add_column :matrix_danger_risks, :date_firm_responsible_sst, :date
    add_column :matrix_danger_risks, :firm_legal_representative, :integer, default: 0 
    add_column :matrix_danger_risks, :firm_adviser_sst, :integer, default: 0
    add_column :matrix_danger_risks, :firm_responsible_sst, :integer, default: 0

    add_column :annual_work_plans, :date_firm_legal_representative, :date
    add_column :annual_work_plans, :date_firm_adviser_sst, :date
    add_column :annual_work_plans, :date_firm_responsible_sst, :date
    add_column :annual_work_plans, :firm_legal_representative, :integer, default: 0 
    add_column :annual_work_plans, :firm_adviser_sst, :integer, default: 0
    add_column :annual_work_plans, :firm_responsible_sst, :integer, default: 0

    add_column :matrix_corrective_actions, :date_firm_legal_representative, :date
    add_column :matrix_corrective_actions, :date_firm_adviser_sst, :date
    add_column :matrix_corrective_actions, :date_firm_responsible_sst, :date
    add_column :matrix_corrective_actions, :firm_legal_representative, :integer, default: 0 
    add_column :matrix_corrective_actions, :firm_adviser_sst, :integer, default: 0
    add_column :matrix_corrective_actions, :firm_responsible_sst, :integer, default: 0

  end
end

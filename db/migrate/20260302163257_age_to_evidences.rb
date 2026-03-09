class AgeToEvidences < ActiveRecord::Migration[7.0]
  def change
    add_column :evidences, :age, :integer, default: 0
    add_column :evidences, :health_promoter_id, :integer, default: 0
    add_column :evidences, :weight, :decimal, default: 0
    add_column :evidences, :company_position_id, :integer, default: 0
    add_column :evidences, :sede, :string
    add_column :evidences, :company_area_id, :integer, default: 0
    add_column :evidences, :type_employment, :integer, default: 0
    add_column :evidences, :medical_treatment, :integer, default: 0
    add_column :evidences, :boss_name, :string
    add_column :evidences, :diagnosis, :string
    add_column :evidences, :type_treatment, :string
    add_column :evidences, :status_compliance, :string
    add_column :evidences, :observations, :string
    add_column :evidences, :collaborator_commitment, :string
    add_column :evidences, :entity_commitment, :string

  end
end

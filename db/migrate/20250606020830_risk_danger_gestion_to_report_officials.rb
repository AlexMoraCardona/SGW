class RiskDangerGestionToReportOfficials < ActiveRecord::Migration[7.0]
  def change
    add_column :report_officials, :risk_danger_gestion, :decimal, default: 0
    add_column :report_officials, :risk_danger_total, :integer, default: 0
    add_column :report_officials, :risk_danger_ges, :integer, default: 0
    add_column :report_officials, :per_training_coverage, :decimal, default: 0
    add_column :report_officials, :training_total, :integer, default: 0
    add_column :report_officials, :training_ges, :integer, default: 0
    add_column :report_officials, :per_scheduled_workers, :decimal, default: 0
    add_column :report_officials, :scheduled_workers, :integer, default: 0
    add_column :report_officials, :trained_workers, :integer, default: 0
    add_column :report_officials, :per_autoevaluation, :decimal, default: 0
    add_column :report_officials, :items_autoevaluation_total, :integer, default: 0
    add_column :report_officials, :items_autoevaluation_cumple, :integer, default: 0
    add_column :report_officials, :per_acpm, :decimal, default: 0
    add_column :report_officials, :acpm_total, :integer, default: 0
    add_column :report_officials, :acpm_cumple, :integer, default: 0
    add_column :report_officials, :compliance_legal, :decimal, default: 0
    add_column :report_officials, :compliance_legal_total, :integer, default: 0
    add_column :report_officials, :compliance_legal_cumple, :integer, default: 0
    add_column :report_officials, :compliance_work_plan, :decimal, default: 0
    add_column :report_officials, :compliance_work_plan_total, :integer, default: 0
    add_column :report_officials, :compliance_work_plan_cumple, :integer, default: 0
    add_column :report_officials, :per_activity_plan, :decimal, default: 0
    add_column :report_officials, :activity_plan_intervenida, :integer, default: 0
    add_column :report_officials, :activity_plan_total, :integer, default: 0
    add_column :report_officials, :per_perfil_sociodemo, :decimal, default: 0
    add_column :report_officials, :perfil_sociodemo_total, :integer, default: 0
    add_column :report_officials, :perfil_sociodemo_encuestados, :integer, default: 0
  end
end

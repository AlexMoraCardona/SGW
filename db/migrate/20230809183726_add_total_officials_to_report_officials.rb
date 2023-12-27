class AddTotalOfficialsToReportOfficials < ActiveRecord::Migration[7.0]
  def change
    add_column :report_officials, :total_officials, :integer, default: 0
    add_column :report_officials, :total_work_accidents, :integer, default: 0
    add_column :report_officials, :total_mortal_accident, :integer, default: 0
    add_column :report_officials, :total_occupational_disease, :integer, default: 0
    add_column :report_officials, :total_laboral_inhability, :integer, default: 0
    add_column :report_officials, :total_common_inhability, :integer, default: 0
    add_column :report_officials, :total_days_absenteeism, :integer, default: 0
  end
end

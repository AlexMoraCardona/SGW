class AddTotalDaysSeveridadAccidentsToReportOfficials < ActiveRecord::Migration[7.0]
  def change
    add_column :report_officials, :total_days_severidad_accidents, :integer, default: 0
    add_column :report_officials, :total_accidents_mortal_year, :integer, default: 0
    add_column :report_officials, :total_accidents_work_year, :integer, default: 0
    add_column :report_officials, :promedio_year_officials, :integer, default: 0
    add_column :report_officials, :total_occupational_disease_year, :integer, default: 0
  end
end

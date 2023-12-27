class AddNumberOficialIndependentToReportOfficials < ActiveRecord::Migration[7.0]
  def change
    add_column :report_officials, :number_oficial_independent, :integer, default: 0 
    add_column :report_officials, :number_oficial_student, :integer, default: 0 
    add_column :report_officials, :number_oficial_temporary, :integer, default: 0 
    add_column :report_officials, :number_oficial_cooperative, :integer, default: 0 
    add_column :report_officials, :number_oficial_other, :integer, default: 0 
  end
end

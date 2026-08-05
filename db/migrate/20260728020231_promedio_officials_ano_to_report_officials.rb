class PromedioOfficialsAnoToReportOfficials < ActiveRecord::Migration[7.0]
  def change
     add_column :report_officials, :promedio_officials_ano, :integer, default: 0
  end
end

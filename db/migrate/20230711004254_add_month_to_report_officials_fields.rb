class AddMonthToReportOfficialsFields < ActiveRecord::Migration[7.0]
  def change
    add_column :report_officials, :year, :integer, default: 0
    add_column :report_officials, :month, :integer, default: 0
    add_column :report_officials, :frecuencia_accidentalidad, :decimal, default: 0
    add_column :report_officials, :severidad_accidentalidad, :decimal, default: 0
    add_column :report_officials, :proporcion_accidentes_mortales, :decimal, default: 0
    add_column :report_officials, :prevalencia_enfermedad_laboral, :decimal, default: 0
    add_column :report_officials, :incidencia_enfermedad_laboral, :decimal, default: 0
    add_column :report_officials, :ausentismo_causa_medica, :decimal, default: 0
  end
end

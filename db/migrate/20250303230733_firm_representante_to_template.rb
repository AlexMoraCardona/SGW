class FirmRepresentanteToTemplate < ActiveRecord::Migration[7.0]
  def change
    add_column :templates, :firm_representante, :integer, default: 0
    add_column :templates, :firm_responsable, :integer, default: 0
    add_column :templates, :firm_asesor, :integer, default: 0
    add_column :templates, :firm_presidente_copasst, :integer, default: 0
    add_column :templates, :firm_secretario_copasst, :integer, default: 0
    add_column :templates, :firm_vigia, :integer, default: 0
    add_column :templates, :participant_responsable, :integer, default: 0
    add_column :templates, :participant_representante, :integer, default: 0
    add_column :templates, :participant_asesor, :integer, default: 0
    add_column :templates, :participant_vigia, :integer, default: 0
    add_column :templates, :participant_colaborador, :integer, default: 0
  end
end

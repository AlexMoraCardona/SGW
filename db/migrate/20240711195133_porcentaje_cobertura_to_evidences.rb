class PorcentajeCoberturaToEvidences < ActiveRecord::Migration[7.0]
  def change
    add_column :evidences, :por_cobertura, :integer, default: 0
    add_column :evidences, :por_trabajadores, :integer, default: 0
    add_column :evidences, :por_reacciones, :integer, default: 0
    add_column :evidences, :por_aprendizaje, :integer, default: 0
    add_column :evidences, :por_resultados, :integer, default: 0
  end
end

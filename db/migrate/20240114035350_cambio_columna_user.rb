class CambioColumnaUser < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :document, :nro_document
  end
end

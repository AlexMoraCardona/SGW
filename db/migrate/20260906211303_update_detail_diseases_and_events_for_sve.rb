class UpdateDetailDiseasesAndEventsForSve < ActiveRecord::Migration[7.0]
  def change

    # Eliminar el campo anterior que almacenaba el SVE como entero
    remove_column :detail_diseases, :sve, :integer

    # Relación opcional entre DetailDisease y SurveillanceConfiguration
    add_reference :detail_diseases,
                  :surveillance_configuration,
                  null: true,
                  foreign_key: true

    # Relación opcional entre Event y DetailDisease
    add_reference :events,
                  :detail_disease,
                  null: true,
                  foreign_key: true

  end
end
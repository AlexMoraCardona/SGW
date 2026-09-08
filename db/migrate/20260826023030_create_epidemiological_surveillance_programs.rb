class CreateEpidemiologicalSurveillancePrograms < ActiveRecord::Migration[7.0]
  def change
    create_table :epidemiological_surveillance_programs do |t|

      # Empresa a la que pertenece el SVE
      t.references :entity,
                   null: false,
                   foreign_key: true

      # Identificación del SVE
      t.string :code
      t.string :name, null: false

      # Información del SVE
      t.text :description
      t.text :objective

      # Vigencia
      t.date :start_date
      t.date :end_date

      # Estado
      t.integer :status,
                null: false,
                default: 0

      # Responsable
      t.references :responsible,
                   foreign_key: { to_table: :users }

      t.timestamps
    end

    # Código único por empresa
    add_index :epidemiological_surveillance_programs,
              [:entity_id, :code],
              unique: true,
              name: 'idx_sve_entity_code'
  end
end
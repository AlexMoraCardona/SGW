class CreateEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :entities do |t|
      t.string :email_entity
      t.integer :kind_person, default: 0
      t.string :business_name
      t.string :first_name
      t.string :second_name
      t.string :surname
      t.string :second_surname
      t.integer :economic_activity, default: 0
      t.string :tax_regime
      t.integer :identification_number
      t.integer :verification_digit
      t.integer :document_type_legal_representative, default: 0
      t.integer :document_number_legal_representative
      t.string :first_name_legal_representative
      t.string :second_name_legal_representative
      t.string :surname_legal_representative
      t.string :second_surname_legal_representative
      t.string :email_legal_representative
      t.integer :phone_number_entity
      t.integer :cell_entity
      t.string :entity_address
      t.integer :entity_location_code, default: 0
      t.string :entity_zone
      t.integer :entity_arl, default: 0
      t.integer :number_workers, default: 0
      t.integer :risk_classification, default: 0
      t.string :license

      t.timestamps
    end
    add_index :entities, :email_entity, unique: true
  end
end

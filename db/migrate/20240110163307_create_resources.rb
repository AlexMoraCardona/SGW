class CreateResources < ActiveRecord::Migration[7.0]
  def change
    create_table :resources do |t|
      t.integer :year, default: 2000
      t.integer :user_legal_representative
      t.integer :user_adviser_sst
      t.integer :user_responsible_sst
      t.integer :version
      t.string :code
      t.date :date_firm_legal_representative
      t.date :date_firm_adviser_sst
      t.date :date_firm_responsible_sst
      t.integer :firm_legal_representative, default: 0
      t.integer :firm_adviser_sst, default: 0
      t.integer :firm_responsible_sst, default: 0

      t.timestamps
    end
    add_reference :resources, :entity, null: true, foreign_key: true
  end
end

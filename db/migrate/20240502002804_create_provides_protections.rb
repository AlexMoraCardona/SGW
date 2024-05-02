class CreateProvidesProtections < ActiveRecord::Migration[7.0]
  def change
    create_table :provides_protections do |t|
      t.integer :user_colaborador
      t.integer :user_responsible
      t.integer :version, default: 0
      t.string :code
      t.date :date_firm_colaborador
      t.date :date_firm_responsible
      t.integer :firm_colaborador, default: 0
      t.integer :firm_responsible, default: 0
      t.string :post_colaborador
      t.string :unit_colaborador

      t.timestamps
    end
    add_reference :provides_protections, :entity, null: true, foreign_key: true
  end
end

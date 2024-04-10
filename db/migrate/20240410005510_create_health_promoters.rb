class CreateHealthPromoters < ActiveRecord::Migration[7.0]
  def change
    create_table :health_promoters do |t|
      t.string :name_entity
      t.string :code_entity
      t.string :nit_entity
      t.string :regime_entity

      t.timestamps
    end
  end
end

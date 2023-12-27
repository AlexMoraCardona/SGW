class CreateOccupationalRiskManagers < ActiveRecord::Migration[7.0]
  def change
    create_table :occupational_risk_managers do |t|
      t.string :name
      t.string :code
      t.boolean :condition, default: true

      t.timestamps
    end
  end
end

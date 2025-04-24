class CreateCompanyPositions < ActiveRecord::Migration[7.0]
  def change
    create_table :company_positions do |t|
      t.string :name

      t.timestamps
    end
    add_reference :company_positions, :entity, null: true, foreign_key: true
  end
end

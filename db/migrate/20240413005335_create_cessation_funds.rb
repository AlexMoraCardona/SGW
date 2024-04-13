class CreateCessationFunds < ActiveRecord::Migration[7.0]
  def change
    create_table :cessation_funds do |t|
      t.string :name
      t.string :nit
      t.string :code

      t.timestamps
    end
  end
end

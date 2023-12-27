class CreateIndicators < ActiveRecord::Migration[7.0]
  def change
    create_table :indicators do |t|
      t.string :name
      t.string :description
      t.references :cycle

      t.timestamps
    end
  end
end

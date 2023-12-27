class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.string :name
      t.string :description
      t.string :reference
      t.timestamps
    end
  end
end

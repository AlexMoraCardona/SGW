class CreateRules < ActiveRecord::Migration[7.0]
  def change
    create_table :rules do |t|
      t.string :name
      t.string :description
      t.date :creation_date
      t.date :date_update

      t.timestamps
    end
  end
end

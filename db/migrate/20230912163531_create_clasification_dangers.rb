class CreateClasificationDangers < ActiveRecord::Migration[7.0]
  def change
    create_table :clasification_dangers do |t|
      t.string :name

      t.timestamps
    end
  end
end

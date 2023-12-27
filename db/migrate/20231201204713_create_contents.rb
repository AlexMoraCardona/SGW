class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.string :clasification
      t.string :title
      t.integer :state, default: 1

      t.timestamps
    end
  end
end

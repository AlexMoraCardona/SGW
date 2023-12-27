class CreateStandars < ActiveRecord::Migration[7.0]
  def change
    create_table :standars do |t|
      t.string :name
      t.string :description
      t.decimal :value, default: 0
      t.integer :cycle, default: 0
      t.integer :rule, default: 0

      t.timestamps
    end
  end
end

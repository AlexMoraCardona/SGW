class CreateStandarDetailItems < ActiveRecord::Migration[7.0]
  def change
    create_table :standar_detail_items do |t|
      t.string :description
      t.decimal :maximun_value, default: 0
      t.integer :standar_detail, default: 0

      t.timestamps
    end
  end
end

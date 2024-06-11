class CreateBusinessDays < ActiveRecord::Migration[7.0]
  def change
    create_table :business_days do |t|
      t.date :date_skilled
      t.integer :day_skilled, default: 0
      t.integer :month_skilled, default: 0
      t.integer :year_skilled, default: 0

      t.timestamps
    end
    add_reference :business_days, :entity, null: true, foreign_key: true
  end
end

class CreateActivityUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_users do |t|
      t.integer :mandatory, default: 0
      t.integer :attended, default: 0
      t.integer :confirm, default: 0
      t.date :date_confirm

      t.timestamps
    end
  end
end

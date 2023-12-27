class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.string :origin
      t.integer :state, default: 0
      t.string :description
      t.string :observation
      t.date :hour
      t.string :place
      t.integer :notify, default: 1

      t.timestamps
    end
  end
end

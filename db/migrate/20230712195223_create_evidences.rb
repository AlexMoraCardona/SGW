class CreateEvidences < ActiveRecord::Migration[7.0]
  def change
    create_table :evidences do |t|
      t.date :date
      t.date :date_update
      t.string :place
      t.string :goals
      t.integer :number_attendees, default: 0
      t.integer :number_officials, default: 0
      t.string :period

      t.timestamps
    end
  end
end

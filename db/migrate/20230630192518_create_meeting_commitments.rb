class CreateMeetingCommitments < ActiveRecord::Migration[7.0]
  def change
    create_table :meeting_commitments do |t|
      t.integer :number
      t.string :commitment
      t.string :responsible
      t.date :date_commitment
      t.string :state_commitment

      t.timestamps
    end
  end
end

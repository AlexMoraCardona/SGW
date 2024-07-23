class CreateCommitments < ActiveRecord::Migration[7.0]
  def change
    create_table :commitments do |t|
      t.string :activity
      t.string :user_responsible
      t.date :date_ejecution
      t.integer :state_commitment

      t.timestamps
    end
  end
end

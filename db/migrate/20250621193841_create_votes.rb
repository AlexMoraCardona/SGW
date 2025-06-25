class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.date :date_vote

      t.timestamps
    end
    add_reference :votes, :user, null: true, foreign_key: true
    add_reference :votes, :adm_vote, null: true, foreign_key: true
    add_reference :votes, :candidate_vote, null: true, foreign_key: true
    add_reference :votes, :habil_vote, null: true, foreign_key: true
  end
end

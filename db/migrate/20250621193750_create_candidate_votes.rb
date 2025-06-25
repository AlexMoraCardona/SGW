class CreateCandidateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :candidate_votes do |t|
      t.string :activity
      t.string :observations

      t.timestamps
    end
    add_reference :candidate_votes, :adm_vote, null: true, foreign_key: true
    add_reference :candidate_votes, :user, null: true, foreign_key: true
  end
end

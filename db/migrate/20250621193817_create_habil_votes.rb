class CreateHabilVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :habil_votes do |t|
      t.integer :vote, default: 0

      t.timestamps
    end
    add_reference :habil_votes, :user, null: true, foreign_key: true
    add_reference :habil_votes, :adm_vote, null: true, foreign_key: true
  end
end

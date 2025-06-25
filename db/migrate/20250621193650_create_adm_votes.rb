class CreateAdmVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :adm_votes do |t|
      t.date :date_initial
      t.date :date_final
      t.integer :total_candidates, default: 0
      t.integer :votes_max, default: 0
      t.string :titulo_vote
      t.string :observation

      t.timestamps
    end
    add_reference :adm_votes, :entity, null: true, foreign_key: true
  end
end

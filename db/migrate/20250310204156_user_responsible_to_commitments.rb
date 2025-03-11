class UserResponsibleToCommitments < ActiveRecord::Migration[7.0]
  def change
    add_reference :commitments, :user, null: true, foreign_key: true
  end
end

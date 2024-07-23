class EvidenceIdToCommiments < ActiveRecord::Migration[7.0]
  def change
    add_reference :commitments, :evidence, null: false, foreign_key: true
    change_column :commitments, :state_commitment, :integer, default: 0
  end
end

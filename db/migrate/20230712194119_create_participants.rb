class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.integer :arl_activity_report, default: 0
      t.integer :quote_10_aditional_points, default: 0
      t.string :degree
      t.integer :designating_by_legal_representative, default: 0
      t.integer :joint_committee_president, default: 0
      t.integer :joint_committee_secretary, default: 0
      t.string :post_copasst

      t.timestamps
    end
  end
end

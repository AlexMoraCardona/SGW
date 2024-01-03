class AddMonthInitialToEvidences < ActiveRecord::Migration[7.0]
  def change
    add_column :evidences, :month_initial, :integer, default: 1
    add_column :evidences, :month_final, :integer, default: 1
    add_column :evidences, :total_votes, :integer, default: 0
    add_column :participants, :jury_voting, :integer, default: 0 
    add_column :participants, :candidate, :integer, default: 0 
    add_column :participants, :number_votes, :integer, default: 0 
    add_column :participants, :workers_representative, :integer, default: 0 
    add_column :participants, :company_representative, :integer, default: 0 

  end
end

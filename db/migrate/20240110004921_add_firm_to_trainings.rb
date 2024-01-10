class AddFirmToTrainings < ActiveRecord::Migration[7.0]
  def change
    add_column :trainings, :date_firm_legal_representative, :date
    add_column :trainings, :date_firm_adviser_sst, :date
    add_column :trainings, :date_firm_responsible_sst, :date
    add_column :trainings, :firm_legal_representative, :integer, default: 0 
    add_column :trainings, :firm_adviser_sst, :integer, default: 0
    add_column :trainings, :firm_responsible_sst, :integer, default: 0
  end
end

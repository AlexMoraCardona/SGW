class AddPersonComplainingToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :person_complaining, :integer, default: 0 
    add_column :evidences, :description_complaint, :string
    add_column :evidences, :data, :string
    add_column :evidences, :evidence_authority, :integer, default: 0
  end
end

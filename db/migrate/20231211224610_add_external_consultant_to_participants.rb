class AddExternalConsultantToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :external_consultant, :integer, default: 0
  end
end

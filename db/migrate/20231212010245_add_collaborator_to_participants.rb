class AddCollaboratorToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :collaborator, :integer, default: 0
  end
end

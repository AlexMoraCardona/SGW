class BrigadepersonnelToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :brigade_personnel, :integer, default: 0
  end
end

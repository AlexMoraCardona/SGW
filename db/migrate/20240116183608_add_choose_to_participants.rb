class AddChooseToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :choose, :integer, default: 0
  end
end

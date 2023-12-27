class AddVigiaToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :vigia, :integer, default: 0 
  end
end

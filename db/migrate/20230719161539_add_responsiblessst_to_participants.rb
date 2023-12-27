class AddResponsiblessstToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :responsible_ssst, :integer, default: 0
  end
end

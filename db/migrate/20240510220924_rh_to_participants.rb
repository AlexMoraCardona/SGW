class RhToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :rh, :string
    add_column :participants, :company_position, :string
    add_column :participants, :phone, :string
    add_column :participants, :brigade_position, :integer, default: 0
  end
end

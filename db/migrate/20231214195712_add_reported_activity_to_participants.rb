class AddReportedActivityToParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :participants, :reported_activity, :string
    add_column :participants, :employees_activity, :string
  end
end

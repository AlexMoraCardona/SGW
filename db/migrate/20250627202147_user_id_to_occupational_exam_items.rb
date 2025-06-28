class UserIdToOccupationalExamItems < ActiveRecord::Migration[7.0]
  def change
     add_column :occupational_exam_items, :user_application, :integer, default: 0
     add_column :investigations, :space_for_injury, :string
     add_column :investigations, :space_for_agente, :string
     add_column :investigations, :de, :string
  end
end

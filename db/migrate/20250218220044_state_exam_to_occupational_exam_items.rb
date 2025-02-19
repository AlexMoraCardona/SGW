class StateExamToOccupationalExamItems < ActiveRecord::Migration[7.0]
  def change
    add_column :occupational_exam_items, :state_exam, :integer, default: 0
  end
end

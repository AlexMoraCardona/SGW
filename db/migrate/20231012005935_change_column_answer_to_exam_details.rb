class ChangeColumnAnswerToExamDetails < ActiveRecord::Migration[7.0]
  def change
    change_column :exam_details, :answer_user, :string
  end
end

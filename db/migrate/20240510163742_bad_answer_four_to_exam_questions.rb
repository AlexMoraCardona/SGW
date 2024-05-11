class BadAnswerFourToExamQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_questions, :bad_answer_four, :string
  end
end

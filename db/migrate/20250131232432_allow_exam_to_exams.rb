class AllowExamToExams < ActiveRecord::Migration[7.0]
  def change
    add_reference :exams, :allow_exam, null: false, foreign_key: true
  end
end

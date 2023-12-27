class AddNameExamToAllowExam < ActiveRecord::Migration[7.0]
  def change
    add_column :allow_exams, :name_exam, :string
  end
end

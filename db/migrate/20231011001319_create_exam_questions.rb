class CreateExamQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_questions do |t|
      t.integer :number, default: 0
      t.string :question
      t.string :bad_answer_one
      t.string :bad_answer_two
      t.string :bad_answer_three
      t.string :good_answe

      t.timestamps
    end
    add_reference :exam_questions, :adm_exam, null: true, foreign_key: true
  end
end

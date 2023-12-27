class CreateExamDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_details do |t|
      t.integer :answer_user, default: 0
      t.integer :correct, default: 0

      t.timestamps
    end
    add_reference :exam_details, :exam, null: true, foreign_key: true
    add_reference :exam_details, :exam_question, null: true, foreign_key: true
  end
end

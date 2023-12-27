class CreateAllowExams < ActiveRecord::Migration[7.0]
  def change
    create_table :allow_exams do |t|
      t.date :date_initial
      t.date :date_final

      t.timestamps
    end
    add_reference :allow_exams, :user, null: true, foreign_key: true
    add_reference :allow_exams, :adm_exam, null: true, foreign_key: true
    add_reference :allow_exams, :entity, null: true, foreign_key: true
  end
end

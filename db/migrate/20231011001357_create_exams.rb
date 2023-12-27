class CreateExams < ActiveRecord::Migration[7.0]
  def change
    create_table :exams do |t|
      t.integer :total_good, default: 0
      t.integer :total_bad, default: 0
      t.decimal :final_percentage, default: 0
      t.integer :time_exam, default: 0

      t.timestamps
    end
    add_reference :exams, :adm_exam, null: true, foreign_key: true
    add_reference :exams, :user, null: true, foreign_key: true
  end
end

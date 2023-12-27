class CreateAdmExams < ActiveRecord::Migration[7.0]
  def change
    create_table :adm_exams do |t|
      t.string :name
      t.string :description
      t.integer :cant_questions, default: 0
      t.decimal :percentage_min
      t.integer :cant_attempts, default: 0
      t.integer :time_max, default: 0

      t.timestamps
    end
  end
end

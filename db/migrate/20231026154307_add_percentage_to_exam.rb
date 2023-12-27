class AddPercentageToExam < ActiveRecord::Migration[7.0]
  def change
    add_column :exams, :percentage_min, :decimal
    add_column :exams, :resul, :string
  end
end

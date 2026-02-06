class DescriptionToAllowExams < ActiveRecord::Migration[7.0]
  def change
    add_column :allow_exams , :description, :string
  end
end

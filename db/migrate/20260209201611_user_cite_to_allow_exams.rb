class UserCiteToAllowExams < ActiveRecord::Migration[7.0]
  def change
    add_column :allow_exams , :user_cites, :string
  end
end

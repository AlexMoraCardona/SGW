class DeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :de_license, :string
    add_column :occupational_exam_items, :emphasis, :string
  end
end

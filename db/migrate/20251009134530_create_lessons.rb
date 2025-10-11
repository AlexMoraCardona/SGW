class CreateLessons < ActiveRecord::Migration[7.0]
  def change
    create_table :lessons do |t|
      t.string :title
      t.integer :user_adviser_sst, default: 0
      t.integer :user_vigia, default: 0
      t.date :date_user_adviser_sst
      t.date :date_user_vigia
      t.integer :firm_user_adviser_sst, default: 0
      t.integer :firm_user_vigia, default: 0

      t.timestamps
    end
    add_reference :lessons, :entity, null: true, foreign_key: true
    add_reference :lessons, :user, null: true, foreign_key: true
    add_column :matrix_corrective_actions, :hallazgo, :string
    change_column :investigations, :phone, :string
  end
end

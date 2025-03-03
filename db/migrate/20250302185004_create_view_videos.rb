class CreateViewVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :view_videos do |t|
      t.string :name_view
      t.integer :presentation, default: 0
      t.integer :type_presentation, default: 0
      t.date :date_view

      t.timestamps
    end
    add_reference :view_videos, :user, null: true, foreign_key: true
    add_column :presentations, :state, :integer, default: 0
  end
end

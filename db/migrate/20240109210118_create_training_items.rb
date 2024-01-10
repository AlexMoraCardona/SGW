class CreateTrainingItems < ActiveRecord::Migration[7.0]
  def change
    create_table :training_items do |t|
      t.integer :consecutive
      t.string :duration
      t.string :training_topic
      t.string :goals
      t.string :scope
      t.string :resources
      t.string :responsible
      t.date :date_training
      t.decimal :training_coverage_percentage
      t.decimal :percentage_trained_workers
      t.string :observation

      t.timestamps
    end
    add_reference :training_items, :training, null: true, foreign_key: true
  end
end

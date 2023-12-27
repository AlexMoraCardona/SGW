class CreateEvaluationModels < ActiveRecord::Migration[7.0]
  def change
    create_table :evaluation_models do |t|
      t.integer :evaluation, default: 0
      t.integer :rule, default: 0
      t.decimal :score, default: 0
      t.decimal :percentage, default: 0

      t.timestamps
    end
  end
end

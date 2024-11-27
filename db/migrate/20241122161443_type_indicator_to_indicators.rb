class TypeIndicatorToIndicators < ActiveRecord::Migration[7.0]
  def change
    change_column :history_evaluations, :score, :decimal, default: 0
    add_column :history_evaluations, :expected_goald, :decimal, default: 0
    add_column :evaluations, :expected_goald, :decimal, default: 0
    add_column :indicators, :type_indicator, :string
    add_column :indicators, :person_result, :string
  end
end

class PeriodicityToIndicators < ActiveRecord::Migration[7.0]
  def change
    add_column :indicators, :periodicity, :integer, default: 0
    add_column :indicators, :formula, :string
    add_column :indicators, :interpretation, :string
    add_column :indicators, :limit_one, :integer, default: 0
    add_column :indicators, :limit_two, :integer, default: 0
    add_column :indicators, :information_source, :string
    add_column :indicators, :responsible_management, :string
  end
end

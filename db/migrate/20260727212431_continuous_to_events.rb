class ContinuousToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :continuous, :integer, default: 0
  end
end

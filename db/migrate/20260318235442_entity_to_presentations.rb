class EntityToPresentations < ActiveRecord::Migration[7.0]
  def change
    add_column :presentations, :entity, :integer, default: 6
  end
end

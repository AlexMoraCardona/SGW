class TypeDangerToDangerPreventions < ActiveRecord::Migration[7.0]
  def change
    add_column :danger_preventions, :type_danger, :integer, default: 0
  end
end

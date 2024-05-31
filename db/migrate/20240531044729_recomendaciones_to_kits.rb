class RecomendacionesToKits < ActiveRecord::Migration[7.0]
  def change
    add_column :kits, :recomendaciones, :string
  end
end

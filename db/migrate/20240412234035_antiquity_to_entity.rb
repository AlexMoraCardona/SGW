class AntiquityToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :pay_entity, :integer, default: 0
    add_column :profiles, :Antiquity, :integer, default: 0
    add_column :profiles, :area_work, :integer, default: 0
  end
end

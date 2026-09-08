class AddSveToDetailDiseases < ActiveRecord::Migration[7.0]
  def change
    add_column :detail_diseases, :sve, :integer, default: 0
  end
end

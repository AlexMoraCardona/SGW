class AddFormatNumberToTemplates < ActiveRecord::Migration[7.0]
  def change
    add_column :templates, :format_number, :integer, default: 0
  end
end

class FirmAssistentToAssistens < ActiveRecord::Migration[7.0]
  def change
    add_column :assistants, :firm_assistant, :integer, default: 0
    add_column :assistants, :date_firm, :date
  end
end

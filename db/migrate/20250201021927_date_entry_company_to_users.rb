class DateEntryCompanyToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :date_entry_company, :date
    add_column :users, :date_retirement_company, :date
  end
end

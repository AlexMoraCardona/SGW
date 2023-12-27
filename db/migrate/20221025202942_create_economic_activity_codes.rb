class CreateEconomicActivityCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :economic_activity_codes do |t|
      t.string :risk_class
      t.string :ciu_code
      t.string :additional_digits
      t.string :economic_activity_description

      t.timestamps
    end
  end
end

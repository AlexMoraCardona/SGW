class CessationFundToProfile < ActiveRecord::Migration[7.0]
  def change
    add_reference :profiles, :cessation_fund, null: true, foreign_key: true
  end
end

class AddLinkToContent < ActiveRecord::Migration[7.0]
  def change
    add_column :contents, :link, :string
  end
end

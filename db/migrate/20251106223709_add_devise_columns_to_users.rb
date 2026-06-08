class AddDeviseColumnsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :\, :string
  end
end

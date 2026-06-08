class AddAvailableToBooks < ActiveRecord::Migration[7.2]
  def change
    add_column :books, :available, :boolean, default: true
  end
end

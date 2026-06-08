class AddResponseMessageToExchangeRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :exchange_requests, :response_message, :text
  end
end

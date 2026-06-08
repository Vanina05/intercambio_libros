class ExchangeRequest < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :book

  # Esta línea asegura que la combinación de sender_id y book_id sea única
  validates :sender_id, uniqueness: { scope: :book_id, message: "ya has enviado una solicitud para este libro" }
end

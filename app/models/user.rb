class User < ApplicationRecord
  has_secure_password

  has_many :books, dependent: :destroy
  has_many :sent_requests, class_name: "ExchangeRequest", foreign_key: "sender_id", dependent: :destroy
  has_many :received_requests, class_name: "ExchangeRequest", foreign_key: "receiver_id", dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, :email, :city, presence: true
  validates :email, uniqueness: true
end

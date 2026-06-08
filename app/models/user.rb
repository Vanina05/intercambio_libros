class User < ApplicationRecord
  # Esto encripta la contraseña
  has_secure_password

  # Antes de guardar, pasamos el email a minúsculas
  before_save { self.email = email.downcase }

  has_many :books, dependent: :destroy
  has_many :sent_requests, class_name: "ExchangeRequest", foreign_key: "sender_id", dependent: :destroy
  has_many :received_requests, class_name: "ExchangeRequest", foreign_key: "receiver_id", dependent: :destroy
  has_many :notifications, dependent: :destroy

  # Validaciones
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :city, presence: true
  validates :description, length: { maximum: 500 }

  # Formato de email con Unicidad
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
end

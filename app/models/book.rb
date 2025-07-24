class Book < ApplicationRecord
  belongs_to :user
  has_many :exchange_requests, dependent: :destroy

  validates :title, :author, :genre, :year, :synopsis, :details, presence: true
end

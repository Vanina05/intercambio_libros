class Book < ApplicationRecord
  belongs_to :user
  has_many :exchange_requests, dependent: :destroy
  # Esto vincula el libro con una imagen
  has_one_attached :image

  validates :title, :author, :genre, :year, :synopsis, :details, presence: true

  def self.search(query)
    if query.present?
      # Normalizamos la búsqueda: quitamos acentos y pasamos a minúsculas
      # Nota: Esto es una aproximación. Para algo perfecto en SQL se usa 'unaccent'
      parameterized_query = I18n.transliterate(query).downcase

      # En la base de datos buscamos de forma simplificada
      where("LOWER(title) LIKE ?", "%#{parameterized_query}%")
    else
      all
    end
  end
end

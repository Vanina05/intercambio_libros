class BooksController < ApplicationController
  before_action :require_login, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    @books = Book.all.includes(:user)
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = current_user.books.build
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      redirect_to books_path, notice: "Libro publicado"
    else
      render :new
    end
  end

  def edit
    @book = current_user.books.find(params[:id])
  end

  def update
    @book = current_user.books.find(params[:id])
    if @book.update(book_params)
      redirect_to @book, notice: "Libro actualizado"
    else
      render :edit
    end
  end

  def destroy
    @book = current_user.books.find(params[:id])
    @book.destroy
    redirect_to books_path, notice: "Libro eliminado"
  end

  def search
    @books = Book.all.includes(:user)

    if params[:query].present?
      # Preparamos la búsqueda
      query_raw = params[:query].downcase
      query_clean = I18n.transliterate(params[:query]).downcase

      # Buscamos de forma flexible
      # Usamos '%#{valor}%' para que encuentre la palabra en cualquier parte del texto
      @books = @books.where(
        "LOWER(title) LIKE ? OR LOWER(title) LIKE ? OR LOWER(author) LIKE ? OR LOWER(author) LIKE ?",
        "%#{query_raw}%", "%#{query_clean}%", "%#{query_raw}%", "%#{query_clean}%"
      )
    end

    if params[:genre].present? && params[:genre] != "Todos los géneros" && params[:genre] != "Todos"
      @books = @books.where(genre: params[:genre])
    end

    render :index
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :genre, :year, :synopsis, :details, :image)
  end

  def require_login
    redirect_to login_path unless current_user
  end
end

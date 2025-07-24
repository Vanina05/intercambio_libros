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
    query = params[:query]
    @books = Book.where("title LIKE ? OR author LIKE ? OR genre LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
    render :index
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :genre, :year, :synopsis, :details)
  end

  def require_login
    redirect_to login_path unless current_user
  end
end

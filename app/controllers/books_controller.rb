class BooksController < ApplicationController
  before_action :set_book, only: [:edit, :update, :destroy]

  def index
    @books = Book.order(created_at: :desc)
    @books = @books.search(params[:q]) if params[:q].present?
    @books = @books.page(params[:page])
  end

  def recent
    @recent_books = Book.order(created_at: :desc).page(params[:page])
  end

  def user
    @user = User.find(params[:user_id])
    @books = @user.books.order(created_at: :desc).page(params[:page])
    render :index
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = current_user.books.new(book_params)

    if @book.save
      redirect_to [:edit, @book], notice: 'Het boek wat met succes aangemaakt. Gelieve nog eens alle info na te kijken en aan te vullen.'
    else
      render :new
    end
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Het boek was met succes aangepast.'
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Het boek is met succes verwijderd.'
  end

  private
    def set_book
      @book = current_user.books.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :introduction, :book, :author, :cover_id)
    end
end

module Api
  class BooksController < BaseController
    def index
      book_ids = Book.order(created_at: :desc).pluck(:id)
      render json: { book_ids: book_ids }
    end

    def show
      book = Book.find(params[:id])
      render json: {
        id: book.id,
        title: book.title,
        author: book.author,
        uploaded_by_email: book.user.email,
        download_url: rails_blob_url(book.book, disposition: "attachment")
      }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Book not found" }, status: :not_found
    end

    private

    def rails_blob_url(blob, disposition:)
      Rails.application.routes.url_helpers.rails_blob_url(blob, disposition: disposition)
    end
  end
end

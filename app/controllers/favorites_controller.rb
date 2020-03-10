class FavoritesController < ApplicationController
  before_action :set_variable
  def create
    @favorite = current_user.favorites.create(book_id: params[:book_id])
  end

  def destroy
    @favorite = Favorite.find_by(book_id: params[:book_id], user_id: current_user.id)
    @favorite.destroy
  end

  private

  def set_variable
    @book = Book.find(params[:book_id])
    @id_name = "#favorite-link-#{@book.id}"
  end

end

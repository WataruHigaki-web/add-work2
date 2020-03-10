class BookCommentsController < ApplicationController

  def create
    @comment = BookComment.new(book_comment_params)
    @comment.book_id = params[:book_id]
    @comment.user_id = current_user.id
    @comment.save
  end

  def destroy
    @comment = BookComment.find(params[:id])
    @comment.user_id = current_user.id
    @comment.destroy
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:content)
  end
  
end

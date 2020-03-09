class UsersController < ApplicationController
  before_action :authenticate_user!
	before_action :baria_user, only: [:update,:edit]

  def show
  	@user = User.find(params[:id])
  	@books = @user.books
  	@book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
  end

  def index
    @user = current_user
  	@users = User.all #一覧表示するためにUserモデルのデータを全て変数に入れて取り出す。
  	@book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
  end

  def search
    @user = current_user
    @book = Book.new
    method = params[:search_method]
    search = params[:search]
    kind = params[:search_kind]
    if kind == "user_name"
      @users = User.search(kind,method,search)
      render 'users/index'
    else
      @books = Book.search(kind,method,search)
      render 'books/index'
    end
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update(user_params)
  		redirect_to user_path(current_user), notice: "successfully updated user!"
  	else
  		render "edit"
  	end
  end

  def following
    @user = User.find(params[:id])
    @users = @user.followings
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follower'
  end

  private

  def user_params
  	params.require(:user).permit(:name, :introduction, :profile_image)
  end

  #url直接防止　メソッドを自己定義してbefore_actionで発動。
   def baria_user
  	unless params[:id].to_i == current_user.id
  		redirect_to user_path(current_user)
  	end
   end

end

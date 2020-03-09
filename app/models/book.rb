class Book < ApplicationRecord
	belongs_to :user
	#バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
	#presence trueは空欄の場合を意味する。
	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
  has_many :favorites
  has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments
  def self.search(kind,method,search)
      if method == "forward_match"
        Book.where("title LIKE?","#{search}%")
      elsif method == "backward_match"
        Book.where("title LIKE?","%#{search}")
      elsif method == "perfect_match"
        Book.where(title: "#{search}")
      elsif method == "partial_match"
        Book.where("title LIKE?","%#{search}%")
      else
        Book.all
      end
  end
end

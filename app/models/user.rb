class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable
  has_many :books, dependent: :destroy
  attachment :profile_image, destroy: false
  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: {maximum: 20, minimum: 2}
  validates :introduction, length: {maximum: 50}

  has_many :favorites, dependent: :destroy
  has_many :favorited_books ,through: :favorites, source: :book
  def already_favorited?(book)
    self.favorites.exists?(book_id: book.id)
  end
  has_many :book_comments

  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_or_create_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def self.search(kind,method,search)
      if method == "forward_match"
        User.where("name LIKE?","#{search}%")
      elsif method == "backward_match"
        User.where("name LIKE?","%#{search}")
      elsif method == "perfect_match"
        User.where(name: "#{search}")
      elsif method == "partial_match"
        User.where("name LIKE?","%#{search}%")
      else
        User.all
      end
  end

  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  before_save :create_address
  def create_address
    self.address = self.prefecture_name + self.address_city + self.address_street 
  end




end

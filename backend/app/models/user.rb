class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable

  has_many :movies, dependent: :destroy

  has_many :movies, dependent: :destroy

  validates :email, presence: true
  with_options if: -> { email.present? } do
    validates :email, uniqueness: true
    validates :email, email_format: true
  end
end

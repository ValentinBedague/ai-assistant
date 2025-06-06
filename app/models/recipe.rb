class Recipe < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_one_attached :image
  
  has_many :chats, dependent: :destroy

  validates :name, presence: true
  validates :portions, presence: true
  validates :ingredients, presence: true
  validates :description, presence: true
end

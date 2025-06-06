class Recipe < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_one_attached :image

  has_many :chats, dependent: :destroy

end

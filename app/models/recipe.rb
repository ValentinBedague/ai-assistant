class Recipe < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :chats, dependent: :destroy
end

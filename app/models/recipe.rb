class Recipe < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_one_attached :image
end

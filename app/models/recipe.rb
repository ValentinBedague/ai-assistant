class Recipe < ApplicationRecord
  has_many :messages, dependent: :destroy
end

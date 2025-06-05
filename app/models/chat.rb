class Chat < ApplicationRecord
  belongs_to :recipe
  has_many :chat_messages, dependent: :destroy
end

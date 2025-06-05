class CreateChatMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_messages do |t|
      t.string :role
      t.text :content
      t.references :chat, null: false, foreign_key: true

      t.timestamps
    end
  end
end

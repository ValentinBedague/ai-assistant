class ChatsController < ApplicationController
  def index
    @recipe = Recipe.find(params[:recipe_id])
    @chats =  Chat.all.where(recipe: @recipe)
    @chat = Chat.new
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @chat = Chat.new(title: "Untitled", model_id: "gpt-4.1-nano")
    @chat.recipe = @recipe
    if @chat.save
      redirect_to chat_path(@chat)
    else
      render :index
    end
  end

  def show
    @chat = Chat.find(params[:id])
    @chat_message = ChatMessage.new
  end
end

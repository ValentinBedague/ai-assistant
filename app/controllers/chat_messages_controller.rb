class ChatMessagesController < ApplicationController

  SYSTEM_PROMPT = "You are a Cooking Assistant. Your outputs need to be realistic and preserve qualitative recipes. Your answers need to respect the language of the user's recipe. Based on the following recipe:\n\n"

  def create
    @chat = Chat.find(params[:chat_id])
    @chat_message = ChatMessage.new(chat_message_params.merge(role: "user", chat: @chat))
    instructions = [SYSTEM_PROMPT, set_context].compact.join("\n\n")
    if @chat_message.save
      build_conversation_history
      @response = @ruby_llm_chat.with_instructions(instructions).ask(@chat_message.content)
      ChatMessage.create(role: "assistant", content: @response.content, chat: @chat)
      if @chat.title == "Untitled"
        @chat.generate_title_from_first_message
      end
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      render "chats/show"
    end
  end

  private

  def set_context
    @context = "Recipe name: #{@chat.recipe.name}\n\nRecipe current portions: #{@chat.recipe.portions}\n\nRecipe current ingredients: #{@chat.recipe.ingredients}\n\nRecipe current step-by-step: #{@chat.recipe.description}"
  end

  def chat_message_params
    params.require(:chat_message).permit(:content)
  end

  def build_conversation_history
    @ruby_llm_chat = RubyLLM.chat
    @chat.chat_messages.each do |message|
      message_params = { role: message.role, content: message.content, chat: message.chat }
      @ruby_llm_chat.add_message(message_params)
    end
  end
end

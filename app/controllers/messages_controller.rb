class MessagesController < ApplicationController
  before_action :set_recipe

  SYSTEM_PROMPT = "You are a Cooking Assistant. Based on the following recipe:\n\n"

  def edit_portions
  end

  def run_edit_portions
    @new_portions = params.require(:recipe).permit(:new_portions)[:new_portions].to_i
    @portion_prompt = "Can you recalculate ingredients for #{@new_portions} portions ? I need the updated list of ingredients (just the list)."
    @instruction = [SYSTEM_PROMPT, set_context].compact.join("\n\n")
    @message = Message.new(role: "user", content: @portion_prompt, recipe: @recipe)
    @chat = RubyLLM.chat
    response = @chat.with_instructions(@instruction).ask(@message.content)
    Message.create(role: "assistant", content: response.content, recipe: @recipe)
    # ToDo : Modifier la recette (champs "displayed")
    # ToDo : Redirect vers la show de la recette
    render :show_edit_portions
  end

  def edit_ingredients
  end

  def run_edit_ingredients
  end

  def run_low_calories
  end

  def chat
  end

  def run_chat
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def set_context
    @context = "Recipe name: #{@recipe.name}\n\nRecipe current portions: #{@recipe.portions}\n\nRecipe current ingredients: #{@recipe.ingredients}\n\nRecipe current step-by-step: #{@recipe.description}"
  end
end

class MessagesController < ApplicationController
  before_action :set_recipe

  SYSTEM_PROMPT = "You are a Cooking Assistant. Your outputs need to be realistic and preserve qualitative recipes. Your answers need to respect the language of the user's recipe. Based on the following recipe:\n\n"

  def edit_portions
  end

  def run_edit_portions
    @new_portions = params.require(:recipe).permit(:new_portions)[:new_portions].to_i
    @portion_prompt = "Can you recalculate ingredients for #{@new_portions} portions ? I need rounded numbers (without deteriorating the recipe). I need the updated list of ingredients (just the list in bullet points)."
    @instruction = [SYSTEM_PROMPT, set_context].compact.join("\n\n")
    @message = Message.new(role: "user", content: @portion_prompt, recipe: @recipe)
    @chat = RubyLLM.chat
    response = @chat.with_instructions(@instruction).ask(@message.content)
    Message.create(role: "assistant", content: response.content, recipe: @recipe)
    @recipe.ingredients_displayed = Message.last.content
    @recipe.portions_displayed = @new_portions
    @recipe.save
    redirect_to recipe_path(@recipe)
  end

  def edit_ingredients
  end

  def run_edit_ingredients
  end

  def run_low_calories
    @portion_prompt = "Help me make this recipe much lower in calories. You can substitute any ingredients. I need a single string that contains:

      # The updated list of ingredients (just the list in bullet points, nothing else),

      # Followed by a £ character as a separator,

      # Then the updated description written step by step, using numbered bullet points (1. , 2. , 3. , etc.)."
    @instruction = [SYSTEM_PROMPT, set_context].compact.join("\n\n")
    @message = Message.new(role: "user", content: @portion_prompt, recipe: @recipe)
    @chat = RubyLLM.chat
    response = @chat.with_instructions(@instruction).ask(@message.content)
    Message.create(role: "assistant", content: response.content, recipe: @recipe)

    parts = Message.last.content.split("£",2)

    @recipe.ingredients_displayed = parts[0]
    @recipe.description_displayed = parts[1]

    if @recipe.save
      redirect_to @recipe, notice: "#{@recipe.name} has been succesfully updated ✅"

    else
      redirect_to @recipe, status: :unprocessable_entity
    end
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

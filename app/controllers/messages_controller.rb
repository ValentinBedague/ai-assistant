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
    @replaced_ingredients = params.require(:recipe).permit(:replaced_ingredients)[:replaced_ingredients]
    @reason = params.require(:recipe).permit(:reason)[:reason]
    @ingredients_prompt = "
        Can you replace the following ingredients: #{@replaced_ingredients}?

        The reason why I want to replace it is that #{@reason}.

        # I need you to keep the original list of ingredients except the #{@replaced_ingredients} and update it with the new ingredient (just the list in bullet points).

        # Followed by a £ character as a separator,

        # Then the updated description given the new ingredients, written step by step, using numbered bullet points (1. , 2. , 3. , etc.)."

    @instruction = [SYSTEM_PROMPT, set_context].compact.join("\n\n")
    @message = Message.new(role: "user", content: @ingredients_prompt, recipe: @recipe)
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

def run_generate_img
  prompt_text = <<~PROMPT
    You are a professional chef and food stylist. Your task is to create an image based on the following recipe details:

    - Recipe Name: #{@recipe.name}
    - Number of Servings: #{@recipe.portions}
    - Ingredients: #{@recipe.ingredients}
    - Instruction of the recipe: #{@recipe.description}

    Please create an image that showcases the dish with attention to color, texture, and presentation. The image should depict the dish in a realistic style, with a focus on making it look delicious and visually enticing. The scene should include:
    - A well-plated dish in a kitchen or dining setting.
    - The main ingredients presented in an artistic and appetizing way.
    - A neutral or rustic background that complements the food.
    - Soft, natural lighting that highlights the textures and colors of the food.

    Make sure the image is high-quality, realistic, and aesthetically pleasing, conveying the feeling of a professional food photography shot.
  PROMPT

  image = RubyLLM.paint(prompt_text, model: "dall-e-3", size: "1024x1024")
  image_url = image&.url

  if image_url.present?
    uploaded_image = Cloudinary::Uploader.upload(image_url)
    @recipe.update(url_image: uploaded_image["secure_url"])
    redirect_to @recipe, notice: "Image generated and recipe updated ✅"
  else
    redirect_to @recipe, alert: "Failed to generate image ❌"
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

class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :reset_recipe]

    SYSTEM_PROMPT = "You are a Cooking Assistant specialized in extracting recipes from images. You must strictly use the original words from the recipe found in the image. Do not paraphrase, invent or translate content."
  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.url_image == ""
      @recipe.url_image = "https://www.ensto-ebs.fr/modules/custom/legrand_ecat/assets/img/no-image.png"
    end
    if @recipe.save
      redirect_to @recipe, notice: "#{@recipe.name} recipe was successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def new_via_img
    @recipe = Recipe.new
  end

  def create_via_img
    @recipe = Recipe.create(recipe_params)
    @img_prompt = "

      You will receive an image of a recipe. It contains four key elements:

      the recipe name

      the number of servings (people it is made for)

      a list of ingredients

      step-by-step instructions

      Analyze the image:

      Extract these four elements and return them as a single string, structured exactly like this:

      The name of the recipe

      £ (as a separator)

      The number of servings (e.g. 4 people)

      £

      The list of ingredients (use bullet points -)

      £

      The step-by-step instructions, using numbered steps (1., 2., etc.)

      ⚠️ Do not add any explanations, headers, or commentary. Return only the final string in this structure."
    @instruction = SYSTEM_PROMPT
    @message = Message.new(role: "user", content: @img_prompt, recipe: @recipe)
    @chat = RubyLLM.chat(model: "gpt-4o")
    response = @chat.with_instructions(@instruction).ask(@message.content, with: {image: @recipe.image.url})

    Message.create(role: "assistant", content: response.content, recipe: @recipe)
    parts = Message.last.content.split("£",4)

    name = parts[0]
    portions = parts[1]
    ingredients = parts[2]
    description = parts[3]

    if @recipe.update(name: name, portions: portions, ingredients: ingredients, description: description, url_image: "https://www.ensto-ebs.fr/modules/custom/legrand_ecat/assets/img/no-image.png")
      redirect_to @recipe, notice: "#{@recipe.name} recipe was successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def reset_recipe
    @recipe.portions_displayed = @recipe.portions
    @recipe.ingredients_displayed = @recipe.ingredients
    @recipe.description_displayed = @recipe.description

    if @recipe.save
      redirect_to @recipe, notice: "#{@recipe.name} has been succesfully reset ✅"
    else
      redirect_to @recipe, status: :unprocessable_entity
    end

  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :portions, :ingredients, :description, :url_image, :image)
  end

end

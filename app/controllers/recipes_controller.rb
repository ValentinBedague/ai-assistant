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

  def new_via_url
    @recipe = Recipe.new
  end

  def create_via_url
    @url = params[:url_recipe][:url]

    # Préparer le prompt pour extraire les informations de la recette à partir de l'URL
    @web_prompt = "
      Here is the url of a recipe page : #{@url}. The page contains the following four key elements:
      1. The recipe name
      2. The number of servings (people it is made for)
      3. A list of ingredients
      4. Step-by-step instructions

      Analyze the page at the URL provided and extract these four elements:
      - The name of the recipe
      - The number of servings
      - The list of ingredients (use bullet points -)
      - The step-by-step instructions (use numbered steps)

      ⚠️ Do not add any explanations, headers, or commentary. Return only the final string in the following structure:
      The name of the recipe
      £ (as a separator)
      The number of servings
      £
      The list of ingredients
      £
      The step-by-step instructions"

    @instruction = SYSTEM_PROMPT

    @message = Message.new(role: "user", content: @web_prompt)
    @chat = RubyLLM.chat(model: "gpt-4o")
    response = @chat.with_instructions(@instruction).ask(@message.content)

    Message.create(role: "assistant", content: response.content)
    raise
    parts = Message.last.content.split("£", 4)

    name = parts[0]
    portions = parts[1]
    ingredients = parts[2]
    description = parts[3]

    @recipe = Recipe.new(name: name, portions: portions, ingredients: ingredients, description: description)

    if @recipe.save
      redirect_to @recipe, notice: "#{@recipe.name} recipe was successfully created!"
    else
      render :new_via_url, status: :unprocessable_entity
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
    params.require(:recipe).permit(:name, :portions, :ingredients, :description, :url_image, :image, :url)
  end

end

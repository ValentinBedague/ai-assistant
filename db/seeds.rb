# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Recipe.destroy_all
puts "Recipes destroyed ❎"
Message.destroy_all
puts "Messages destroyed ❎"

puts "Creating recipes..."

Recipe.create!(
    name: "Pancakes moelleux",
    portions: 4,
    ingredients:  "200g farine, 2 œufs, 300ml lait, 1 sachet levure, 1 c. à soupe sucre, 1 pincée sel",
    description: " 1. Dans un saladier, mélange la farine, la levure, le sucre et le sel.
    2. Ajoute les œufs, puis le lait progressivement en fouettant.
    3. Laisse reposer la pâte 10 minutes.
    4. Fais cuire des petites louches de pâte dans une poêle chaude huilée.
    5. Retourne quand des bulles se forment. Dore de chaque côté.",
    url_image: 'https://www.allrecipes.com/thmb/FE0PiuuR0Uh06uVh1c2AsKjRGbc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/21014-Good-old-Fashioned-Pancakes-mfs_002-0e249c95678f446291ebc9408ae64c05.jpg'
  )
puts " a Pancakes moelleux recipe has been created ✅"

Recipe.create!(
    name: "Salade quinoa avocat",
    portions: 2,
    ingredients:  "150g quinoa, 1 avocat, 1 citron, 1 poignée roquette, 1 c. à soupe huile d’olive, sel, poivre",
    description: "1. Fais cuire le quinoa dans de l'eau bouillante pendant 12 minutes.
    2. Égoutte et laisse refroidir.
    3. Coupe l'avocat en dés, arrose de jus de citron.
    4. Mélange tous les ingrédients dans un saladier.
    5. Assaisonne avec l’huile, sel et poivre. Sers frais.",
    url_image: 'https://img.hellofresh.com/f_auto,fl_lossy,q_auto,w_1200/hellofresh_s3/image/HF201106_R208_W01_FR_QFR20161818-1_KB_Main_low-c8bd6ee4.jpg'
  )
puts " a Salade quinoa avocat recipe has been created ✅"

Recipe.create!(
    name: "Curry de légumes coco",
    portions: 3,
    ingredients:  "1 oignon, 2 carottes, 1 courgette, 200ml lait de coco, 1 c. à soupe pâte de curry, 1 c. à soupe huile",
    description: " 1. Émince l’oignon, coupe les légumes en dés.
    2. Fais revenir l’oignon dans l’huile jusqu’à ce qu’il soit doré.
    3. Ajoute les légumes et fais revenir 5 minutes.
    4. Ajoute la pâte de curry et le lait de coco.
    5. Laisse mijoter à feu doux pendant 15 à 20 minutes.",
    url_image: 'https://wordpress.potagercity.fr/wp-content/uploads/2019/09/recette_curry_legume.jpg'
  )
puts " a Curry de légumes coco recipe has been created ✅"


Recipe.create!(
  name: "Salade de pois chiches à la feta",
  portions: 2,
  ingredients: "200g pois chiches cuits, 100g feta, 1 tomate, 1/2 oignon rouge, 1 c. à soupe huile d’olive, jus d’un demi citron, sel, poivre",
  description: "1. Égoutte les pois chiches et rince-les.
  2. Coupe la tomate et l’oignon en petits dés, émiette la feta.
  3. Mélange tous les ingrédients dans un saladier.
  4. Arrose d’huile d’olive et de jus de citron.
  5. Sale, poivre, puis mélange délicatement et sers frais.",
  url_image: 'https://fodyfoods.ca/cdn/shop/articles/Chickpea_Salad_1.jpg?v=1682344636'
)
puts "Salade de pois chiches à la feta recipe has been created ✅"

Recipe.create!(
  name: "Nachos gratinés au cheddar",
  portions: 4,
  ingredients: "1 sachet de chips tortillas, 150g cheddar râpé, 1 petite boîte haricots rouges, 2 c. à soupe sauce salsa, 1 avocat, crème fraîche, jalapeños (optionnel)",
  description: "1. Préchauffe le four à 200°C.
  2. Étale les chips tortillas sur une plaque recouverte de papier cuisson.
  3. Répartis les haricots rouges, la salsa et le cheddar râpé par-dessus.
  4. Enfourne 5 à 8 minutes jusqu’à ce que le fromage soit fondu.
  5. Ajoute des tranches d’avocat, une cuillerée de crème fraîche et des jalapeños au moment de servir.",
  url_image: 'https://img.hellofresh.com/f_auto,fl_lossy,q_auto,w_1200/hellofresh_s3/image/sheet-pan-nachos-485d5dcf.jpg'
)
puts "Nachos gratinés au cheddar recipe has been created ✅"

puts "5 recipes have been created 🚀"


# require 'faker'

# Recipe.destroy_all
# puts "Recipes destroyed ❎"
# Message.destroy_all
# puts "Messages destroyed ❎"

# puts "Creating recipes..."

# NBSEED = 5

# NBSEED.times do |i|
#   name = Faker::Food.dish
#   portions = rand(1..8)
#   ingredients = []
#   descriptions = []

#   15.times do
#     ingredients << "#{Faker::Food.ingredient} - #{(50..1000).step(50).to_a.sample}g"
#   end

#   15.times do
#     descriptions << "#{Faker::Food.description}"
#   end


#   Recipe.create!(
#     name: name,
#     portions: portions,
#     ingredients: ingredients.sample(rand(4..6)).join("\n"),
#     description: descriptions.sample(rand(4..6)).join("\n")
#   )
#   puts " a #{name} recipe has been created ✅"
# end

# puts "#{NBSEED} #{'recipe'.pluralize(NBSEED)} have been created 🚀"

//
//  HomeViewController.swift
//  RecipeRally
//
//  Created by manh on 2025-04-12.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // Array to hold fetched Recipe objects
    var recipes: [Recipe] = []
    
    // Reference to Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100

        // Preload recipes if needed (this will import from the plist)
        preloadRecipesIfNeeded()
        
        // Fetch recipes from Core Data
        fetchRecipes()
    }
    
    // MARK: - Preloading Data
    
    func preloadRecipesIfNeeded() {
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            print("Current Recipe count: \(count)")
            // If count is zero, import recipes
            if count == 0 {
                importRecipesFromPlist()
            } else {
                print("Data already exists in store. To test updated import, delete the app or clear the store.")
            }
        } catch {
            print("Error checking recipe count: \(error)")
        }
    }
    
    func importRecipesFromPlist() {
        guard let url = Bundle.main.url(forResource: "RecipeData", withExtension: "plist") else {
            print("RecipeData.plist not found.")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            if let recipesArray = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [[String: Any]] {
                print("Importing \(recipesArray.count) recipes.")
                for recipeDict in recipesArray {
                    let recipe = Recipe(context: context)
                    recipe.dishName = recipeDict["dishName"] as? String
                    recipe.cuisine = recipeDict["cuisine"] as? String
                    recipe.stepToMake = recipeDict["stepToMake"] as? String
                    recipe.picture = recipeDict["picture"] as? String
                    recipe.mainIngredient = recipeDict["mainIngredient"] as? String
                              
                    // Set the transformable attribute "ingredient" with the array of strings.
                    if let ingredientArray = recipeDict["ingredient"] as? [String] {
                        recipe.ingredient = ingredientArray as NSArray
                        print("DEBUG: For recipe \(recipe.dishName ?? "Unnamed"), imported ingredients: \(ingredientArray)")
                    } else {
                        print("DEBUG: No ingredient array found for recipe \(recipe.dishName ?? "Unnamed")")
                    }
                }
                try context.save()
                print("Imported \(recipesArray.count) recipes from plist.")
            } else {
                print("Failed to convert plist data.")
            }
        } catch {
            print("Error importing recipes from plist: \(error)")
        }
    }
    
    // MARK: - Fetching Recipes
    
    func fetchRecipes() {
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        do {
            recipes = try context.fetch(request)
            print("Fetched \(recipes.count) recipes.")
            // For each fetched recipe, log the ingredients value:
            for recipe in recipes {
                if let ing = recipe.ingredient as? [String] {
                    print("DEBUG: Recipe '\(recipe.dishName ?? "Unnamed")' has ingredients: \(ing)")
                } else {
                    print("DEBUG: Recipe '\(recipe.dishName ?? "Unnamed")' has no ingredients (or wrong format).")
                }
            }
            tableView.reloadData()
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Make sure your storyboard cell's identifier is set to "RecipeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        let recipe = recipes[indexPath.row]
        
        cell.textLabel?.text = recipe.dishName ?? "No Dish Name"
        
        // Display cuisine and ingredients (using transformable attribute "ingredient")
        if let ingredientArray = recipe.ingredient as? [String] {
            cell.detailTextLabel?.text = (recipe.cuisine ?? "Unknown Cuisine") + " | " + ingredientArray.joined(separator: ", ")
        } else {
            cell.detailTextLabel?.text = recipe.cuisine ?? "Unknown Cuisine"
        }
        
        if let imageName = recipe.picture, let image = UIImage(named: imageName) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(systemName: "photo")
        }

        // Set a fixed size for the imageView
        let imageSize = CGSize(width: 80, height: 80)
        cell.imageView?.frame = CGRect(origin: .zero, size: imageSize)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = recipes[indexPath.row]
        print("Selected: \(selectedRecipe.dishName ?? "N/A")")
        tableView.deselectRow(at: indexPath, animated: true)
        // If you're using a cell-based storyboard segue, the segue will be triggered automatically.
    }
    
    // Prepare for segue: pass the selected Recipe to RecipeDetailViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetail",
           let detailVC = segue.destination as? RecipeDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let selectedRecipe = recipes[indexPath.row]
            detailVC.recipe = selectedRecipe
            print("DEBUG: Passing recipe \(selectedRecipe.dishName ?? "Unnamed") to detail view.")
        }
    }
}

//
//  FilteredRecipesViewController.swift
//  RecipeRally
//
//  Created by manh on 2025-04-12.
//

import UIKit
import CoreData

class FilteredRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // This array is populated from the previous screen with selected ingredient names.
    var filteredIngredients: [String] = []
    
    // Array to hold the filtered Recipe objects.
    var filteredRecipes: [Recipe] = []
    
    // Reference to Core Data context.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchFilteredRecipes()
    }
    
    // MARK: - Fetch Filtered Recipes
    
    func fetchFilteredRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        var predicates: [NSPredicate] = []
        
        // Build a predicate for each selected ingredient.
        for ingredient in filteredIngredients {
            let predicate = NSPredicate(format: "ANY ingredients.name ==[cd] %@", ingredient)
            predicates.append(predicate)
        }
        
        // Combine with OR so a recipe with any matching ingredient is fetched.
        if !predicates.isEmpty {
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
            request.predicate = compoundPredicate
        }
        
        do {
            filteredRecipes = try context.fetch(request)
            print("Fetched \(filteredRecipes.count) recipes matching: \(filteredIngredients)")
            tableView.reloadData()
        } catch {
            print("Error fetching filtered recipes: \(error)")
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Make sure your storyboard cell identifier is "FilteredRecipeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilteredRecipeCell", for: indexPath)
        let recipe = filteredRecipes[indexPath.row]
        
        cell.textLabel?.text = recipe.dishName ?? "No Dish Name"
        
        // Use the relationship 'ingredients' to display ingredient names.
        if let ingredientsSet = recipe.ingredients as? Set<Ingredient> {
            let names = ingredientsSet.compactMap { $0.name }
            cell.detailTextLabel?.text = (recipe.cuisine ?? "Unknown Cuisine") + " | " + names.joined(separator: ", ")
        } else {
            cell.detailTextLabel?.text = recipe.cuisine ?? "Unknown Cuisine"
        }
        
        // Display image for the recipe.
        if let imageName = recipe.picture, let image = UIImage(named: imageName) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(systemName: "photo")
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = filteredRecipes[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Perform the segue using the identifier "showRecipeDetail" and pass the selected Recipe.
        performSegue(withIdentifier: "showRecipeDetail", sender: selectedRecipe)
    }
    
    // Prepare for segue: pass the selected Recipe to the RecipeDetailViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetail",
           let detailVC = segue.destination as? RecipeDetailViewController,
           let selectedRecipe = sender as? Recipe {
            detailVC.recipe = selectedRecipe
        }
    }
    
    // Optional: custom row height.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 4
    }
}

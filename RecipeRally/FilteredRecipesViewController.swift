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
    
    // This array is populated from the selection screen with user-chosen ingredient names.
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
        
        // For each selected ingredient, build a predicate checking the new mainIngredient attribute.
        for ingredient in filteredIngredients {
            let predicate = NSPredicate(format: "mainIngredient ==[cd] %@", ingredient)
            predicates.append(predicate)
            print("DEBUG: Adding predicate: mainIngredient ==[cd] \(ingredient)")
        }
        
        if !predicates.isEmpty {
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
            request.predicate = compoundPredicate
            print("DEBUG: Combined Predicate: \(compoundPredicate)")
        } else {
            print("DEBUG: No filtered ingredients provided; fetching all recipes.")
        }
        
        do {
            filteredRecipes = try context.fetch(request)
            print("Fetched \(filteredRecipes.count) recipes matching: \(filteredIngredients)")
            // Debug: Print mainIngredient for each fetched recipe.
            for recipe in filteredRecipes {
                print("DEBUG: Recipe '\(recipe.dishName ?? "Unnamed")' has mainIngredient: \(recipe.mainIngredient ?? "nil")")
            }
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
        // Ensure your storyboard cell identifier is "FilteredRecipeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilteredRecipeCell", for: indexPath)
        let recipe = filteredRecipes[indexPath.row]
        
        cell.textLabel?.text = recipe.dishName ?? "No Dish Name"
        
        // Display cuisine and mainIngredient details.
        if let mainIng = recipe.mainIngredient, !mainIng.isEmpty {
            cell.detailTextLabel?.text = "\(recipe.cuisine ?? "Unknown Cuisine") | Main: \(mainIng)"
        } else {
            cell.detailTextLabel?.text = recipe.cuisine ?? "Unknown Cuisine"
        }
        
        // Display the recipe image.
        if let imageName = recipe.picture, let image = UIImage(named: imageName) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(systemName: "photo")
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    // Remove performSegue here since the segue is connected directly from the cell.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // For a cell-based segue, simply deselect the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetail",
           let detailVC = segue.destination as? RecipeDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let selectedRecipe = filteredRecipes[indexPath.row]
            detailVC.recipe = selectedRecipe
            print("DEBUG: Passing recipe '\(selectedRecipe.dishName ?? "Unnamed")' to detail view.")
        }
    }
    
    // Optional: custom row height.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 4
    }
}

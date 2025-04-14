//
//  DishListViewController.swift
//  RecipeRally
//
//  Created by manh on 2025-04-13.
//
import UIKit
import CoreData
class DishListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var selectedCuisine: String?
    var filteredRecipes: [Recipe] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        print("Selected cuisine: \(selectedCuisine ?? "None")")
        fetchRecipesByCuisine()
    }

    func fetchRecipesByCuisine() {
        guard let cuisine = selectedCuisine else { return }
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "cuisine == %@", cuisine)
        
        do {
            filteredRecipes = try context.fetch(request)
            print("Fetched \(filteredRecipes.count) recipes for cuisine: \(cuisine)")
            tableView.reloadData()
        } catch {
            print("Failed to fetch: \(error)")
        }
    }

    // MARK: - Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath)
        let recipe = filteredRecipes[indexPath.row]
        cell.textLabel?.text = recipe.dishName
        return cell
    }
}

//
//  RecipeDetailViewController.swift
//  RecipeRally
//
//  Created by manh on 2025-04-12.
//

import UIKit
import CoreData  // Important if you're referencing NSManagedObject subclasses

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var stepsTextView: UITextView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    // This is set by the FilteredRecipesViewController
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let recipe = recipe else { return }
        
        // Display the dish name
        dishNameLabel.text = recipe.dishName
        
        // Display the steps
        stepsTextView.text = recipe.stepToMake
        
        // Display the ingredients as a comma-separated list
        // Convert the NSSet? to a Set<Ingredient>, then map each Ingredient’s name.
        if let ingredientsSet = recipe.ingredients as? Set<Ingredient> {
            let ingredientNames = ingredientsSet.compactMap { $0.name }
            ingredientsLabel.text = "Ingredients: " + ingredientNames.joined(separator: ", ")
        } else {
            ingredientsLabel.text = "Ingredients: N/A"
        }
        
        // Display the image
        if let imageName = recipe.picture, let image = UIImage(named: imageName) {
            recipeImageView.image = image
        } else {
            recipeImageView.image = UIImage(systemName: "photo")
        }
    }
}

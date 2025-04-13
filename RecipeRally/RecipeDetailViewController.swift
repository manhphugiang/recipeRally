//
//  RecipeDetailViewController.swift
//  RecipeRally
//
//  Created by manh on 2025-04-12.
//

import UIKit
import CoreData  // Needed for NSManagedObject subclasses

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var stepsTextView: UITextView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    // This property is set by the previous view controller (via segue)
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let recipe = recipe else {
            print("DEBUG: No recipe was passed to RecipeDetailViewController!")
            return
        }
        
        // Display the dish name and steps
        dishNameLabel.text = recipe.dishName
        stepsTextView.text = recipe.stepToMake
        
        // Display ingredients:
        // Since you're not using a relationship, we expect recipe.ingredient to store an NSArray of Strings.
        if let ingredientArray = recipe.ingredient as? [String] {
            let ingredientList = ingredientArray.joined(separator: "\n")
            ingredientsLabel.text = "Ingredients:\n\n" + ingredientList
            print("DEBUG: Ingredients found: \(ingredientArray)")
        } else {
            ingredientsLabel.text = "Ingredients: N/A"
            print("DEBUG: No ingredients found in recipe. ('ingredient' attribute is nil or not an array of strings)")
        }
        
        // Display the image
        if let imageName = recipe.picture, let image = UIImage(named: imageName) {
            recipeImageView.image = image
        } else {
            recipeImageView.image = UIImage(systemName: "photo")
        }
    }
}

//
//  RecipeDetailViewController.swift
//  RecipeRally
//
//  Created by manh on 2025-04-12.
//

import UIKit
import CoreData

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var stepsTextView: UITextView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
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
        if let ingredientArray = recipe.ingredient as? [String] {
            let ingredientList = ingredientArray.joined(separator: "\n")
            ingredientsLabel.text = "Ingredients:\n\n" + ingredientList
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

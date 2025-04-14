//
//  CuisineSelectionViewController.swift
//  RecipeRally
//
//  Created by manh on 2025-04-13.
//

import UIKit

class CuisineSelectionViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var canadianButton: UIButton!
    @IBOutlet weak var italianButton: UIButton!  // You can keep this if needed
    var selectedCuisine: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select a Cuisine"
        // (Assuming you've already set constraints, backgrounds, images, etc. in your storyboard)
    }
    
    // MARK: - IBActions
    
    @IBAction func canadianButtonTapped(_ sender: UIButton) {
        // When Canadian is tapped, pass the string "Canadian"
        selectedCuisine = "Canadian"

    }
    
    @IBAction func italianButtonTapped(_ sender: UIButton) {
        // For illustration – if you want to handle the Italian button,
        // pass the exact string as stored in your data, e.g., "Italia".
        selectedCuisine = "Italia"

    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDishList",
           let dishListVC = segue.destination as? DishListViewController {
            dishListVC.selectedCuisine = selectedCuisine
        }
    }

}

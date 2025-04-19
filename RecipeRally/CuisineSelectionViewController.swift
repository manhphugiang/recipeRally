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
    @IBOutlet weak var italianButton: UIButton!
    var selectedCuisine: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select a Cuisine"
    }
    
    // MARK: - IBActions
    
    @IBAction func canadianButtonTapped(_ sender: UIButton) {
        // When Canadian is tapped, pass the string "Canadian"
        selectedCuisine = "Canadian"

    }
    
    @IBAction func italianButtonTapped(_ sender: UIButton) {
        // When Canadian is tapped, pass the string "Italia"
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

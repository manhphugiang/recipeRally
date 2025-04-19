//
//  SelectIngredientViewController.swift
//  RecipeRally
//
//  Created by manh on 2025-04-12.
//
import UIKit

struct IngredientOption {
    let imageName: String
    let displayName: String
    var isSelected: Bool
}

class SelectIngredientViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var findRecipeButton: UIButton!
    
    var ingredientOptions: [IngredientOption] = [
        IngredientOption(imageName: "onion",   displayName: "Onion",    isSelected: false),
        IngredientOption(imageName: "butter",  displayName: "Butter",   isSelected: false),
        IngredientOption(imageName: "tomato",  displayName: "Tomato",   isSelected: false),
        IngredientOption(imageName: "cheese",  displayName: "Cheese",   isSelected: false),
        IngredientOption(imageName: "tofu",    displayName: "Tofu",     isSelected: false),
        IngredientOption(imageName: "potato",  displayName: "Potato",   isSelected: false),
        IngredientOption(imageName: "egg",     displayName: "Egg",      isSelected: false),
        IngredientOption(imageName: "flour",   displayName: "Flour",    isSelected: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SelectIngredientViewController viewDidLoad called")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Set a visible background color so you can see the collection view's frame
        collectionView.backgroundColor = .systemGray5
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = ingredientOptions.count
        print("Number of Items: \(count)")
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientCell", for: indexPath) as? IngredientCell else {
            fatalError("Unable to dequeue IngredientCell.")
        }
        
        let option = ingredientOptions[indexPath.row]
        cell.ingredientLabel.text = option.displayName
        
        if let image = UIImage(named: option.imageName) {
            cell.ingredientImageView.image = image
            print("Loaded image for \(option.imageName)")
        } else {
            print("Failed to find image named \(option.imageName)")
            cell.ingredientImageView.image = UIImage(systemName: "photo")
        }
        
        // Visually indicate selection
        cell.contentView.backgroundColor = option.isSelected
            ? UIColor.systemGreen.withAlphaComponent(0.3)
            : UIColor.clear
        
        return cell
    }

    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ingredientOptions[indexPath.row].isSelected.toggle()
        collectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let padding: CGFloat = 8
        let totalPadding = padding * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - totalPadding
        let widthPerItem = availableWidth / itemsPerRow
        
        // Extra vertical space for the label
        let cellSize = CGSize(width: widthPerItem, height: widthPerItem + 80)
        print("Cell size: \(cellSize)")
        return cellSize
    }
    
    // MARK: - Actions
    
    @IBAction func findRecipeButtonTapped(_ sender: UIButton) {
        let selectedIngredients = ingredientOptions
            .filter { $0.isSelected }
            .map { $0.displayName }
        
        guard !selectedIngredients.isEmpty else {
            let alert = UIAlertController(title: "No Selection",
                                          message: "Please select at least one ingredient.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultsVC = storyboard.instantiateViewController(withIdentifier: "FilteredRecipesViewController") as? FilteredRecipesViewController {
            resultsVC.filteredIngredients = selectedIngredients
            navigationController?.pushViewController(resultsVC, animated: true)
        }
    }
}

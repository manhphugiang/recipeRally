//
//  IngredientCellCollectionViewCell.swift
//  RecipeRally
//
//  Created by manh on 2025-04-12.
//

import UIKit

class IngredientCell: UICollectionViewCell {
    @IBOutlet var ingredientImageView: UIImageView!
    @IBOutlet var ingredientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientImageView.contentMode = .scaleAspectFit
        ingredientImageView.clipsToBounds = true
        
        ingredientLabel.textAlignment = .center
    }
}

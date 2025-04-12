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
        
        // Ensure the image content mode is set at runtime too
        ingredientImageView.contentMode = .scaleAspectFit
        ingredientImageView.clipsToBounds = true
        
        // Optionally configure the label (font, text alignment, etc.)
        ingredientLabel.textAlignment = .center
    }
}

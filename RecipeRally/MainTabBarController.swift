//
//  MainTabBarController.swift
//  RecipeRally
//
//  Created by manh on 2025-04-11.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Option 1: If you configured the tab bar controllers via Storyboard,
        // this method can be empty.
        
        // Option 2: To set up the child view controllers programmatically,
        // uncomment the following code and ensure you have set the correct Storyboard IDs for each.

        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Home Tab
        guard let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? UIViewController else {
            fatalError("HomeViewController not found")
        }
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        // Cuisine Tab
        guard let cuisineVC = storyboard.instantiateViewController(withIdentifier: "CuisineViewController") as? UIViewController else {
            fatalError("CuisineViewController not found")
        }
        cuisineVC.tabBarItem = UITabBarItem(title: "Cuisine", image: UIImage(systemName: "leaf"), tag: 1)
        
        // Settings Tab
        guard let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? UIViewController else {
            fatalError("SettingsViewController not found")
        }
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        
        // Set the view controllers for the tab bar.
        viewControllers = [homeVC, cuisineVC, settingsVC]
        */
    }
}

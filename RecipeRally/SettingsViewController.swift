//
//  SettingsViewController.swift
//  RecipeRally
//
//  Created by manh on 2025-04-11.
//

import Foundation
import UIKit
import FBSDKLoginKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogoutButton()
    }
    
    private func configureLogoutButton() {
        if let token = AccessToken.current, !token.isExpired {
            logoutButton.setTitle("Logout from Facebook", for: .normal)
        } else {
            logoutButton.setTitle("Logout", for: .normal)
        }
    }
    
    // MARK: - IBAction for Logout Button
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        // If logged in with Facebook, log out.
        if let token = AccessToken.current, !token.isExpired {
            let loginManager = LoginManager()
            loginManager.logOut()
            print("Logged out from Facebook")
        }
        resetToLoginScreen()
    }
    
    private func resetToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateInitialViewController() {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = loginVC
                window.makeKeyAndVisible()
            } else {
                UIApplication.shared.windows.first?.rootViewController = loginVC
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        } else {
            print("Failed.")
        }
    }
}

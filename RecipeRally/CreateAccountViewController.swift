//
//  CreateAccountViewController.swift
//  RecipeRally
//
//  Created by manh on 2025-04-11.
//

import Foundation

import UIKit
import CoreData

class CreateAccountViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else {
            showAlert(withMessage: "Please enter a username.")
            return
        }
        
        if userExists(username) {
            showAlert(withMessage: "User already exists, please choose a different username.")
        } else {
            // Create a new user.
            createUser(username)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Core Data Helpers
    
    private func userExists(_ username: String) -> Bool {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            print("Error checking user: \(error)")
            return false
        }
    }
    
    private func createUser(_ username: String) {
        let newUser = User(context: context)
        newUser.username = username
        
        do {
            try context.save()
            print("User \(username) created successfully!")
        } catch {
            showAlert(withMessage: "Error saving user: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Alert Helper
    private func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Create Account", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

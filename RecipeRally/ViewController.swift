import UIKit
import CoreData
import FBSDKLoginKit

class ViewController: UIViewController, LoginButtonDelegate {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!
    
    // Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Facebook login button
        let fbButton = FBLoginButton()
        fbButton.permissions = ["public_profile"]
        fbButton.delegate = self
        fbButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fbButton)
        NSLayoutConstraint.activate([
            fbButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fbButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 20)
        ])
        
        // Debug: Log initial default user creation check
        createDefaultUserIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If the user is already logged in via Facebook, go directly to the main screen.
        if let token = AccessToken.current, !token.isExpired {
            print("Facebook token exists, redirecting to main tab bar")
            redirectToMainTabBar()
        }
    }
    
    // MARK: - Facebook Login
    
    func loginButton(_ loginButton: FBLoginButton,
                     didCompleteWith result: LoginManagerLoginResult?,
                     error: Error?) {
        if let error = error {
            print("Facebook login error: \(error)")
            return
        }
        guard let result = result, !result.isCancelled else {
            print("Facebook login cancelled by user.")
            return
        }
        fetchFacebookUserProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged out of Facebook.")
    }
    
    private func fetchFacebookUserProfile() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
        request.start { [weak self] (_, result, error) in
            guard let self = self else { return }
            if let error = error {
                print("Failed to get Facebook user info: \(error)")
                return
            }
            if let userData = result as? [String: Any],
               let fbName = userData["name"] as? String {
                print("Facebook user name fetched: \(fbName)")
                self.handleUsernameLogin(fbName)
            } else {
                self.handleUsernameLogin("FacebookUser")
            }
        }
    }
    
    // MARK: - Username Login Actions

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // If text field is not empty, use entered username; otherwise, use default ("a").
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if username.isEmpty {
            print("Username text field is empty. Using default username 'a'.")
            createDefaultUserIfNeeded() // Create if needed
            redirectToMainTabBar()
        } else {
            if !userExists(username) {
                let alert = UIAlertController(title: "Username Not Found",
                                              message: "The username you entered was not found. Please try again or create an account.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            } else {
                print("Login successful with username: \(username)")
                redirectToMainTabBar()
            }
        }
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else {
            let alert = UIAlertController(title: "Missing Username",
                                          message: "Please enter a username.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        if userExists(username) {
            let alert = UIAlertController(title: "User Exists",
                                          message: "User already exists, please choose a different username.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            createUser(username)
            print("New user '\(username)' created.")
            // Return back to previous screen (Login) if using a navigation controller.
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Core Data Helpers
    
    private func handleUsernameLogin(_ username: String) {
        if !userExists(username) {
            createUser(username)
        } else {
            print("User \(username) already exists.")
        }
        redirectToMainTabBar()
    }
    
    private func userExists(_ username: String) -> Bool {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
        do {
            let result = try context.fetch(request)
            print("userExists(\(username)): found \(result.count) match(es)")
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
            print("User \(username) saved successfully!")
        } catch {
            print("Error saving user: \(error)")
        }
    }
    
    // This function creates a default user with username "a" if one does not already exist.
    private func createDefaultUserIfNeeded() {
        let defaultUsername = "a"
        if !userExists(defaultUsername) {
            createUser(defaultUsername)
            print("Default user '\(defaultUsername)' created automatically.")
        } else {
            print("Default user '\(defaultUsername)' already exists.")
        }
    }
    
    // MARK: - Redirect to Main Tab Bar
    
    private func redirectToMainTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainTabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else {
            print("Could not instantiate UITabBarController with identifier 'MainTabBarController'")
            return
        }
        mainTabBarVC.modalPresentationStyle = .fullScreen
        present(mainTabBarVC, animated: true, completion: nil)
    }
}

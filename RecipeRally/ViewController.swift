import UIKit
import CoreData
import FBSDKLoginKit

class ViewController: UIViewController, LoginButtonDelegate {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Facebook login button
        let fbButton = FBLoginButton()
        fbButton.permissions = ["public_profile", "email"]
        fbButton.delegate = self
        fbButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fbButton)
        NSLayoutConstraint.activate([
            fbButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fbButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 20)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if the user is already logged in via Facebook
        if let token = AccessToken.current, !token.isExpired {
            redirectToMainTabBar()
        }
    }
    
    // MARK: - Facebook LoginButtonDelegate Methods
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
                self.handleUsernameLogin(fbName)
            } else {
                self.handleUsernameLogin("FacebookUser")
            }
        }
    }
    
    // MARK: - Actions for Username-Only Login Flow
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let typedUsername = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !typedUsername.isEmpty else {
            print("Username cannot be empty.")
            return
        }
        if userExists(typedUsername) {
            print("User exists. Logging in.")
            redirectToMainTabBar()
        } else {
            print("User does not exist. Please create an account first.")
        }
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        let typedUsername = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !typedUsername.isEmpty else {
            print("Username cannot be empty.")
            return
        }
        if userExists(typedUsername) {
            print("User already exists, choose a different username.")
        } else {
            createUser(typedUsername)
            print("New user created, logging in.")
            redirectToMainTabBar()
        }
    }
    
    // MARK: - Core Data Helpers
    private func handleUsernameLogin(_ username: String) {
        if !userExists(username) {
            createUser(username)
        }
        redirectToMainTabBar()
    }
    
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
        } catch {
            print("Error saving user: \(error)")
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

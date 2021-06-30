import Foundation
import FirebaseAuth

public class AuthManager
{
    static let shared = AuthManager()
    
    //MARK: - Public
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void)
    {
        /*
         - Check if username is available
         - Check if email is available
         - Create account
         - Insert account to database
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate
            {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else {
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    // Insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted
                        {
                            completion(true)
                            return
                        }
                        else
                        {
                            // Failed to insert to database
                            completion(false)
                            return
                        }
                    }
                }
            }
            else
            {
                //either username or email does not exists
                completion(false)
            }
        }
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void)
    {
        if let email = email
        {
            //email login
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username
        {
            //username login
            print("\(username)")
        }
    }
    
    /// Attempt to logout firebase user
    public func logout(completion: (Bool) -> Void)
    {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print(error)
            completion(false)
            return
        }
    }
}

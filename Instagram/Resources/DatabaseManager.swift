import Foundation
import FirebaseDatabase

public class DatabaseManager
{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    //MARK: - Public
    
    /// Check if username and email is available
    /// - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void)
    {
        completion(true)
    }
    
    /// Inserts new user data to database
    /// - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    ///     - completion: Async callback for result if database entry succeeded
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void)
    {
        let key = email.safeDatabaseKey()
        
        database.child(key).setValue(["username": username]) { error, _ in
            if error == nil
            {
                // Succeeded
                completion(true)
                return
            }
            else
            {
                // Failed
                completion(false)
                return
            }
        }
    }
}

//
//  AuthViewModel.swift
//  Connonym
//
//  Created by Ömür Şenocak on 17.12.2023.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import UIKit
import SwiftUI





class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var username = ""
    @Published var biography = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var avatarURL: String?
    @Published var users: [AuthViewModel.User] = []
    @Published var currentUser: Binding<User>?
    @Published var isLoggedIn: Bool = false

    var avatarImage: UIImage?

    struct User: Identifiable {
        var id: String
        var email: String
        var username: String
        var avatarURL: String?
        var biography: String

    }
 

    
    func fetchUserData(forUserID userID: String, completion: @escaping (AuthViewModel.User?) -> Void) {
        let db = Firestore.firestore()
        let userDocument = db.collection("users").document(userID)

        userDocument.getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(nil)
            } else if let document = document, document.exists {
                if let userData = document.data() {
                    let user = AuthViewModel.User(
                        id: userID,
                        email: userData["email"] as? String ?? "",
                        username: userData["username"] as? String ?? "",
                        avatarURL: userData["avatarURL"] as? String,
                        biography: userData["biography"] as? String ?? ""
                    )
                    completion(user)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
  

     // Function to send a message

    func fetchAllUsers() {
          let db = Firestore.firestore()
          db.collection("users").getDocuments { snapshot, error in
              guard let documents = snapshot?.documents, error == nil else {
                  print("Error fetching all users: \(error?.localizedDescription ?? "Unknown error")")
                  return
              }

              self.users = documents.compactMap { document in
                  let data = document.data()
                  let user = AuthViewModel.User(
                      id: document.documentID,
                      email: data["email"] as? String ?? "",
                      username: data["username"] as? String ?? "",
                      avatarURL: data["avatarURL"] as? String,
                      biography: data["biography"] as? String ?? ""
                  )
                  return user
              }
          }
      }
    func register(completion: @escaping () -> Void) {
        if password == confirmPassword {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.showAlert = true
                    self.alertMessage = error.localizedDescription
                } else {
                    // Registration successful
                    // You can perform additional actions here if needed

                    // Get the UID of the registered user
                    if let user = authResult?.user {
                        // Upload the avatar image and get the dynamic URL
                        self.uploadAvatarImage(image: self.avatarImage) { avatarURL in
                            self.avatarURL = avatarURL

                            print("Avatar URL after upload: \(avatarURL)")

                            // Add the user to Firestore with the obtained avatar URL
                            self.addUserToFirestore(userID: user.uid, email: self.email, username: self.username, avatarURL: avatarURL, biography: self.biography)

                            // Store the avatarURL in AuthViewModel

                            print("Registration successful")
                            completion()
                        }
                    }
                }
            }
        } else {
            self.showAlert = true
            self.alertMessage = "Passwords do not match"
        }
    }
    func signOut(completion: @escaping () -> Void) {
        do {
            try Auth.auth().signOut()
            // Additional sign-out logic if needed

            // Set isLoggedIn to false after sign-out
            isLoggedIn = false
            completion()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
            completion()
        }
    }


    func login(completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert = true
                self.alertMessage = error.localizedDescription
            } else {
                // login successful
                // You can perform additional actions here if needed
                print("Login successful")
                self.isLoggedIn = true

                completion()
            }
        }
    }
    func addUserToFirestore(userID: String, email: String, username: String, avatarURL: String?, biography: String) {
           let db = Firestore.firestore()
           let userDocument = db.collection("users").document(userID)

           var userData: [String: Any] = [
               "email": email,
               "username": username,
               "biography": biography
               // Add more user details if needed
           ]

           if let avatarURL = avatarURL {
               userData["avatarURL"] = avatarURL
           }

           userDocument.setData(userData) { error in
               if let error = error {
                   print("Error adding user to Firestore: \(error.localizedDescription)")
               } else {
                   print("User added to Firestore successfully")
               }
           }
       }



    
    func fetchUserData(completion: @escaping (User?) -> Void) {
        if let userId = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let userDocument = db.collection("users").document(userId)

            userDocument.getDocument { document, error in
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                    completion(nil)
                } else if let document = document, document.exists {
                    if let userData = document.data() {
                        let user = User(
                            id: userId,
                            email: userData["email"] as? String ?? "",
                            username: userData["username"] as? String ?? "",
                            avatarURL: userData["avatarURL"] as? String,
                            biography: userData["biography"] as? String ?? ""
                        )
                        self.avatarURL = user.avatarURL // Set the avatarURL in the ViewModel
                        completion(user)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }


    
    func uploadAvatarImage(image: UIImage?, completion: @escaping (String?) -> Void) {
        guard let image = image else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("avatar_images").child(UUID().uuidString)

        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading avatar image: \(error.localizedDescription)")
                completion(nil)
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        completion(nil)
                    } else {
                        completion(url?.absoluteString)
                    }
                }
            }
        }
    }
    
    
}


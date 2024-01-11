//
//  ChatViewModel.swift
//  Connonym
//
//  Created by Ömür Şenocak on 25.12.2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import UIKit
import FirebaseFirestoreSwift

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatViewModel.Message] = []
    @Published var User: [AuthViewModel.User] = []
 
    struct Message: Identifiable, Equatable, Decodable, Encodable {
        var id: String
        var content: String
        var senderID: String
        var receiverID: String
        var timestamp: Date
    }
    
    struct RecentMessage: Identifiable, Equatable{
        var user: User
        var id: String
        var content: String
        var senderID: String
        var receiverID: String
        var timestamp: Date
    }
    
    func hasConversation(withUserID userID: String) -> Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated.")
            return false
        }

        let conversationExists = messages.contains { message in
            (message.senderID == currentUserID && message.receiverID == userID) ||
            (message.senderID == userID && message.receiverID == currentUserID)
        }

        print("Checking conversation with user \(userID): \(conversationExists)")

        return conversationExists
    }


    
    /*
    func fetchMessages(forUserID userID: String, completion: @escaping ([Message]) -> Void) {
        let db = Firestore.firestore()
        let messagesCollection = db.collection("messages")

        let currentUserID = Auth.auth().currentUser?.uid ?? ""

        messagesCollection
            .whereField("senderID", in: [currentUserID, userID])
            .whereField("receiverID", in: [currentUserID, userID])
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    completion([])
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No messages available")
                    completion([])
                    return
                }

                let messages = documents.compactMap { document -> Message? in
                    do {
                        let messageData = try document.data(as: Message.self)
                        return messageData
                    } catch {
                        print("Error decoding message: \(error.localizedDescription)")
                        return nil
                    }
                }

                print("Fetched \(messages.count) messages:")
                for message in messages {
                    print("Message ID: \(message.id), Content: \(message.content)")
                }

                DispatchQueue.main.async {
                    self.messages = messages
                }

                completion(messages)
            }
    }
     */
    
    func updateChatUsers(forUserID userID: String, completion: @escaping ([Message], [AuthViewModel.User]) -> Void){
        let db = Firestore.firestore()
        let chattedUsersCollection = db.collection("chattedUsers")
        
        let currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        chattedUsersCollection
            .whereField("senderID", in: [currentUserID, userID])
            .whereField("receiverID", in: [currentUserID, userID])
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    completion([], [])
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No messages available")
                    completion([], [])
                    return
                }
                let messages = documents.compactMap { document -> Message? in
                    do {
                        let messageData = try document.data(as: Message.self)
                        return messageData
                    } catch {
                        print("Error decoding message: \(error.localizedDescription)")
                        return nil
                    }
                }

                var senders: [AuthViewModel.User] = []

                // Fetch sender information for each message 
                for message in messages {
                    self.fetchUserInfo(forUserID: message.senderID) { senderInfo in
                        senders.append(senderInfo)
                        // Debugging information
                        print("Fetched Sender for Message \(message.id)")
                    }
                }


                DispatchQueue.main.async {
                    self.messages = messages
                }

                completion(messages, senders)
            }
    }
    func fetchMessages(forUserID userID: String, completion: @escaping ([Message], [AuthViewModel.User]) -> Void) {
        let db = Firestore.firestore()
        let messagesCollection = db.collection("messages")

        let currentUserID = Auth.auth().currentUser?.uid ?? ""

        messagesCollection
            .whereField("senderID", in: [currentUserID, userID])
            .whereField("receiverID", in: [currentUserID, userID])
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    completion([], [])
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No messages available")
                    completion([], [])
                    return
                }

                let messages = documents.compactMap { document -> Message? in
                    do {
                        let messageData = try document.data(as: Message.self)
                        return messageData
                    } catch {
                        print("Error decoding message: \(error.localizedDescription)")
                        return nil
                    }
                }

                var senders: [AuthViewModel.User] = []

                // Fetch sender information for each message
                for message in messages {
                    self.fetchUserInfo(forUserID: message.senderID) { senderInfo in
                        senders.append(senderInfo)
                        // Debugging information
                        print("Fetched Sender for Message \(message.id)")
                    }
                }


                DispatchQueue.main.async {
                    self.messages = messages
                }

                completion(messages, senders)
            }
    }
    
    

    func fetchUserInfo(forUserID userID: String, completion: @escaping (AuthViewModel.User) -> Void) {
        let db = Firestore.firestore()
        let userDocument = db.collection("users").document(userID)

        userDocument.getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(AuthViewModel.User(id: "", email: "", username: "", avatarURL: nil, biography: ""))
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
                    completion(AuthViewModel.User(id: "", email: "", username: "", avatarURL: nil, biography: ""))
                }
            } else {
                completion(AuthViewModel.User(id: "", email: "", username: "", avatarURL: nil, biography: ""))
            }
        }
    }

    private let db = Firestore.firestore()

    func sendMessage(content: String, toUserID: String, completion: @escaping () -> Void) {
          guard let currentUserID = Auth.auth().currentUser?.uid else {
              print("User is not authenticated.")
              return
          }

          let db = Firestore.firestore()
          let messagesCollection = db.collection("messages")

          // Check if there is an existing conversation with the recipient
          let existingConversation = messages.first { message in
              (message.senderID == currentUserID && message.receiverID == toUserID) ||
              (message.senderID == toUserID && message.receiverID == currentUserID)
          }

          if existingConversation == nil {
              // If there is no existing conversation, increment sohbetCount
              updateSohbetCount(forUserID: currentUserID)
              updateSohbetCount(forUserID: toUserID)
          }

          let newMessage = Message(
              id: UUID().uuidString,
              content: content,
              senderID: currentUserID,
              receiverID: toUserID,
              timestamp: Date()
          )

          do {
              try messagesCollection.addDocument(from: newMessage) { error in
                  if let error = error {
                      print("Error sending message: \(error.localizedDescription)")
                  } else {
                      print("Message sent successfully")
                      self.updateChatUsers(forUserID: currentUserID){_,_ in 
                          completion()
                      }
                               // Check if the message is added to the local messages array
                               print("Messages array after sending message: \(self.messages)")
                                                     
                      completion()
                  }
              }
          } catch {
              print("Error encoding message: \(error.localizedDescription)")
          }
      }


    func fetchSohbetCount(forUserID userID: String, completion: @escaping (Int) -> Void) {
        let db = Firestore.firestore()
        let userDocument = db.collection("users").document(userID)

        userDocument.getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(0)
            } else if let document = document, document.exists {
                if let sohbetCount = document.data()?["sohbetCount"] as? Int {
                    completion(sohbetCount)
                } else {
                    completion(0)
                }
            } else {
                completion(0)
            }
        }
    }
    
      private func updateSohbetCount(forUserID userID: String) {
          let db = Firestore.firestore()
          let userDocument = db.collection("users").document(userID)

          userDocument.getDocument { document, error in
              if let error = error {
                  print("Error fetching user data: \(error.localizedDescription)")
              } else if let document = document, document.exists {
                  var userData = document.data() ?? [:]

                  if let sohbetCount = userData["sohbetCount"] as? Int {
                      userData["sohbetCount"] = sohbetCount + 1
                  } else {
                      userData["sohbetCount"] = 1
                  }

                  userDocument.setData(userData) { error in
                      if let error = error {
                          print("Error updating sohbetCount: \(error.localizedDescription)")
                      } else {
                          print("sohbetCount updated successfully")
                      }
                  }
              }
          }
      }
    /*
    func sendMessage(content: String, toUserID: String, completion: @escaping () -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated.")
            return
        }

        let db = Firestore.firestore()
        let messagesCollection = db.collection("messages")

        let newMessage = Message(
            id: UUID().uuidString,
            content: content,
            senderID: currentUserID,
            receiverID: toUserID,  // Use the recipientUserID
            timestamp: Date()
        )

        do {
            try messagesCollection.addDocument(from: newMessage) { error in
                if let error = error {
                    print("Error sending message: \(error.localizedDescription)")
                } else {
                    print("Message sent successfully")
                    completion()
                }
            }
        } catch {
            print("Error encoding message: \(error.localizedDescription)")
        }
    }
    */





}

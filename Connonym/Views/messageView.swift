//
//  messageView.swift
//  Connonym
//
//  Created by Ömür Şenocak on 19.12.2023.
//
import SwiftUI
import Firebase
import FirebaseFirestore
import SwiftUI

struct MessageCell: View {
    var message: ChatViewModel.Message
    
    var body: some View {
        HStack {
            if message.senderID == Auth.auth().currentUser?.uid {
                Spacer() // Add spacer to push the content to the edge
            }
            Text(message.content)
                .padding(10)
                .foregroundColor(.white)
                .background(message.senderID == Auth.auth().currentUser?.uid ? Color.green : Color.blue)
                .cornerRadius(10)
            
            if message.senderID != Auth.auth().currentUser?.uid {
                Spacer() // Add spacer to push the content to the edge
            }
        }.padding(.horizontal)
        
    }
    
}


struct messageView: View {
    var recipientUserID: String
    @ObservedObject var messagesViewModel: ChatViewModel
    @State private var newMessageText: String = ""

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(messagesViewModel.messages, id: \.id) { message in
                        MessageCell(message: message)
                    }    
                 
                  

                }
            }

            HStack {
                TextField("Type a message...", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Send") {
                    messagesViewModel.sendMessage(content: newMessageText, toUserID: recipientUserID) {
                        newMessageText = ""
                    }

                }
                .padding(.trailing)
            }
            .padding()
        }
        .navigationBarTitle("Messages", displayMode: .inline)
        .onAppear {
            messagesViewModel.fetchMessages(forUserID: recipientUserID) { messages, user  in
                print("Fetched \(messages.count) messages")
            }
        }
    }
}


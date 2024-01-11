//
//  recentMessagesView.swift
//  Connonym
//
//  Created by Ömür Şenocak on 1.01.2024.
//

/*
import Firebase
import SwiftUI
import SDWebImageSwiftUI
struct RecentMessagesView: View {
    @ObservedObject private var chatViewModel = ChatViewModel()
    @State private var recentMessages: [(message: ChatViewModel.Message, sender: AuthViewModel.User)] = []

    var body: some View {
        VStack {
            List(recentMessages, id: \.message.id) { recentMessage in
                NavigationLink(destination: MessageDetailView(message: recentMessage.message, otherUser: recentMessage.sender)) {
                    RecentMessageRow(message: recentMessage.message, otherUser: recentMessage.sender)
                }
            }
        }
        .navigationBarTitle("Recent Messages")
        .onAppear {
            chatViewModel.fetchRecentContacts { recentContacts in
                chatViewModel.fetchRecentMessages(recentContacts) { fetchedRecentMessages in
                    recentMessages = fetchedRecentMessages
                }
            }
        }
    }
}



struct RecentMessageRow: View {
    var message: ChatViewModel.Message
    var otherUser: AuthViewModel.User

    var body: some View {
        HStack {
            WebImage(url: URL(string: otherUser.avatarURL ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(otherUser.username)
                    .font(.headline)
                Text(message.content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()

            Spacer()
        }
        .padding(.horizontal, 8)
    }
}

struct MessageDetailView: View {
    var message: ChatViewModel.Message
    var otherUser: AuthViewModel.User

    var body: some View {
        // Your message detail view implementation
        Text("Message Detail View")
            .navigationBarTitle("Chat with \(otherUser.username)", displayMode: .inline)
    }
}
*/

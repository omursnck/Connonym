//
//  shuffleView.swift
//  Connonym
//
//  Created by Ömür Şenocak on 18.12.2023.
//

import SwiftUI


import Firebase
import SDWebImageSwiftUI


struct shuffleView: View {
    @ObservedObject private var authViewModel = AuthViewModel()
    @ObservedObject private var messagesViewModel = ChatViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
              

                
                ForEach(authViewModel.users) { user in
                    NavigationLink(destination: messageView(recipientUserID: user.id, messagesViewModel: messagesViewModel)) {
                        UserCell(user: user, authViewModel: authViewModel)
                    }
                }
            }
            .navigationTitle("Shuffle")
            .onAppear {
                authViewModel.fetchAllUsers()
            }
        }

        .navigationBarBackButtonHidden()
    }
}

struct UserCell: View {
    var user: AuthViewModel.User
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        HStack() {
            WebImage(url: URL(string: user.avatarURL ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.headline)
                Text(user.biography)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }.padding()
            Spacer()

        }
        .padding(.horizontal, 8)
    }
}








// UserProfileView.swift
import SwiftUI
import SDWebImageSwiftUI

struct UserProfileView: View {
    @State private var isOnline: Bool = true
    @State private var sohbetCount: Int = 92
    @State private var begeniCount: Int = 3
    @State private var biography: String = ""
    
    var user: AuthViewModel.User
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View   {
        NavigationView{
            ScrollView{
                if let avatarURL = user.avatarURL {
                    WebImage(url: URL(string: avatarURL))
                        .resizable()
                        .scaledToFit()
                        .frame(height: UIScreen.main.bounds.height / 2)
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .frame(height: UIScreen.main.bounds.height / 2)
                }
                
                
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        if let avatarURL = user.avatarURL {
                            WebImage(url: URL(string: avatarURL))
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                        } else {
                            Image(systemName: "person")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(user.username)")
                                .font(.subheadline)
                                .fontWeight(.black)
                            Text(isOnline ? "Çevrimiçi" : "Çevrimdışı")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(isOnline ? Color.green : Color.red)
                        }
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(10)
                                .foregroundStyle(Color.white)
                                .background(Color.purple)
                                .clipShape(Circle())
                        })
                        
                        Button(action: {}, label: {
                            Image(systemName: "link")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(10)
                                .foregroundStyle(Color.white)
                                .background(Color.purple)
                                .clipShape(Circle())
                        })
                    }
                    
                    VStack {
                        HStack {
                            Image(systemName: "bubble.left.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(10)
                            Text("Sohbet")
                                .font(.subheadline)
                                .fontWeight(.black)
                            
                            Spacer()
                            Text("\(sohbetCount) Kişiyle Sohbet Etti")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        Divider()
                        HStack {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(10)
                            Text("Beğeni")
                                .font(.subheadline)
                                .fontWeight(.black)
                            
                            Spacer()
                            
                            Text("\(begeniCount) Beğeni Aldı")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Biography")
                            .font(.subheadline)
                            .fontWeight(.black)
                        
                        Text("\(user.biography)")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)
            }
        }
    }
}

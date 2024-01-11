//
//  profileView.swift
//  Connonym
//
//  Created by Ömür Şenocak on 17.12.2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI

struct profileView: View {
    @StateObject private var viewModel = AuthViewModel()
    @ObservedObject private var chatViewModel = ChatViewModel()

    @State private var user: AuthViewModel.User?
    @State private var isOnline: Bool = true
    @State private var sohbetCount: Int = 0 // Initial value
    @State private var begeniCount: Int = 3
    @State private var biography: String = ""
    @State private var shouldRefresh: Bool = false

    var body: some View {
        
        
        VStack(spacing: 10) {
                if let avatarURL = viewModel.avatarURL {
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
                    if let avatarURL = viewModel.avatarURL {
                        WebImage(url: URL(string: avatarURL))
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)                    }
             

                    if let user = user {
                        VStack(alignment: .leading) {
                            Text("\(user.username)")
                                .font(.subheadline)
                                .fontWeight(.black)
                            Text(isOnline ? "Çevrimiçi" : "Çevrimdışı")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(isOnline ? Color.green : Color.red)
                        }
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
                    
                    NavigationLink(destination: loginView(), isActive: $shouldRefresh) {
                                   EmptyView()
                               }
                               .navigationBarHidden(true)
                    
                    Button(action: {
                        viewModel.signOut {
                            shouldRefresh = true

                        }
                    }, label: {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .resizable()
                            .offset(x:3)
                            .frame(width: 24, height: 24)
                            .padding(10)
                            .foregroundStyle(Color.white)
                            .background(Color.purple)
                            .clipShape(Circle())
                    })
                    .padding(.leading,8)
                }

                VStack {
                    
                    Divider()
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
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Biography")
                        .font(.subheadline)
                        .fontWeight(.black)

                    Text("\(biography)")
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .ignoresSafeArea()
        .onAppear {
            print("ViewModel Avatar URL: \(viewModel.avatarURL ?? "N/A")")

            viewModel.fetchUserData { user in
                if let user = user {
                    self.user = user
                    self.biography = user.biography // Set the actual biography value
                    chatViewModel.fetchSohbetCount(forUserID: user.id) { sohbetCount in
                                         self.sohbetCount = sohbetCount
                                     }
                }
            }
        }
        .onReceive(viewModel.$avatarURL) { newAvatarURL in
            if let newAvatarURL = newAvatarURL {
                print("Avatar URL in profileView: \(newAvatarURL)")
            } else {
                print("Avatar URL in profileView: N/A")
            }
        }

    }
}

struct profileView_Previews: PreviewProvider {
    static var previews: some View {
        profileView()
    }
}

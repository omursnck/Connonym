//
//  ContentView.swift
//  Connonym
//
//  Created by Ömür Şenocak on 17.12.2023.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var registerBiography = ""

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                /*
                  RecentMessagesView()
                  
                      .tabItem {
                          Image(systemName: "envelope.open.badge.clock")
                          Text("Recent Messages")
                      }
                      .tag(0)
                 */
                shuffleView()
                
                    .tabItem {
                        Image(systemName: "shuffle")
                        Text("Shuffle")
                    }
                    .tag(1)
                
                
                profileView()
                
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .tag(2)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

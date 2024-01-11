//
//  loginView.swift
//  Connonym
//
//  Created by Ömür Şenocak on 17.12.2023.
//

import SwiftUI

struct loginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isNavigationActive = false  // Added state for navigation
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.purple
                VStack(spacing: 10) {
                    
                    VStack(alignment:.center){
                        Text("Giriş Yap")
                            .font(.system(size: 26))
                            .bold()
                            .foregroundStyle(Color.white)
                        Text("Oturum açmak için kullanıcı adını veya email adresini kullanabilirsin")
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.75)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.white)
                        
                        
                        CustomTextField(text: $viewModel.email, prompt: "Email")
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        CustomSecureField(text: $viewModel.password, placeholder: "Password")
                        
                    }.padding(.top,150)
                    
                    NavigationLink(
                        destination: ContentView(),  // Navigate to ContentView after successful login
                        isActive: $isNavigationActive,  // Activate the NavigationLink programmatically
                        label: {
                            EmptyView()  // An EmptyView is used as a label because NavigationLink requires a label
                        }
                    )
                    .navigationBarBackButtonHidden()
                    .hidden()  // Hide the actual NavigationLink view
                    .onAppear {
                        // Reset the navigation state when the view appears
                        isNavigationActive = false
                    }
                    
                    NavigationLink(destination: registerView()) {
                        Text("Don't have an account? Register Now!")
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    VStack{
                        Button("Login") {
                            viewModel.login {
                                // Handle registration completion if needed
                                // Set the state to activate the NavigationLink
                                isNavigationActive = true
                            }
                        }
                        .bold()
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.purple)
                        .cornerRadius(30)
                    }.padding(.bottom,40)
                }
                .padding()
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .ignoresSafeArea()
        }.navigationBarBackButtonHidden()
    }
}

struct loginView_Previews: PreviewProvider {
    static var previews: some View {
        loginView()
    }
}

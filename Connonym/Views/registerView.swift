//
//  registerView.swift
//  Connonym
//
//  Created by Ömür Şenocak on 17.12.2023.
//

import SwiftUI
import PhotosUI


struct registerView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var avatarImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isNavigationActive = false  // Added state for navigation

    var body: some View {
        NavigationView {
            ZStack {
                Color.purple.ignoresSafeArea()

                VStack(spacing: 10) {
                    VStack {
                        if let avatarImage = avatarImage {
                            Image(uiImage: avatarImage)
                                .resizable()
                                .clipShape(Circle())
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        } else {
                            Button(action: {
                                isImagePickerPresented = true
                            }, label: {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.white)
                            })
                            .padding()
                            .padding(.top, 100)
                        }
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePickerRepresentation(selectedImage: $avatarImage)
                    }

                    CustomTextField(text: $viewModel.email, prompt: "Email")
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(PlainTextFieldStyle())

                    CustomTextField(text: $viewModel.username, prompt: "Username")
                        .autocorrectionDisabled()
                        .textFieldStyle(PlainTextFieldStyle())

                    CustomSecureField(text: $viewModel.password, placeholder: "Password")
                        .textFieldStyle(PlainTextFieldStyle())

                    CustomSecureField(text: $viewModel.confirmPassword, placeholder: "Confirm Password")
                        .textFieldStyle(PlainTextFieldStyle())

                    CustomTextField(text: $viewModel.biography, prompt: "Biography")
                        .autocorrectionDisabled()
                        .textFieldStyle(PlainTextFieldStyle())

                    NavigationLink(destination: loginView()) {
                        Text("Do you have an account? Sign in Now!")
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
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
                    Button("Register") {
                        if let uiImage = avatarImage {
                            viewModel.avatarImage = uiImage
                            viewModel.register {
                                isNavigationActive = true

                                // Handle registration completion if needed
                            }
                        } else {
                            // Handle the case where avatarImage is nil
                            print("Avatar image is nil.")
                        }
                    }
                    .bold()
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.purple)
                    .cornerRadius(30)
                    .padding(.bottom, 40)
                }
                .padding()
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct registerView_Previews: PreviewProvider {
    static var previews: some View {
        registerView()
    }
}

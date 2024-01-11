//
//  CustomFields.swift
//  Connonym
//
//  Created by Ömür Şenocak on 18.12.2023.
//

import SwiftUI


struct CustomTextField: View {
    @Binding var text: String
    var prompt: String

    var body: some View {
        TextField("", text: $text, prompt: Text(prompt).foregroundColor(.gray))
            .padding()
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(10)
            .textFieldStyle(PlainTextFieldStyle())
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
      
        SecureField("",
                        text: $text,
                        prompt: Text("Password")
                                  .foregroundColor(.gray)
              )
            .padding()
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(10)
            .textFieldStyle(PlainTextFieldStyle())
    }
}



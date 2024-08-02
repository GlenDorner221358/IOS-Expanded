//
//  FirebaseAuthView.swift
//  bababooie
//
//  Created by student on 2024/08/02.
//

import SwiftUI

struct FirebaseAuthView: View {
    
    @ObservedObject var firebaseAuthManager = FirebaseAuthManager()
    
    var body: some View {
        VStack{
            Text("Firebase Auth")
                .padding()
            
            TextField("Email", text: $firebaseAuthManager.email)
                .padding()
            
            SecureField("Password", text: $firebaseAuthManager.password)
                .padding()
            
            Button(action: {
                firebaseAuthManager.signup()
            }) {
                Text("Create User")
            }.padding()
            
            Button(action: {
                firebaseAuthManager.login()
            }) {
                Text("Login")
            }.padding()
            
            Spacer()
        }
    }
}

#Preview {
    FirebaseAuthView()
}

//
//  ContentView.swift
//  Stepper
//
//  Created by Glen on 2024/07/26.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @AppStorage("isOnboarded") private var isOnboarded = false

    @ObservedObject var firebaseAuthManager = FirebaseAuthManager()
    
    @State public var isLoggedIn: Bool = false

    var body: some View {
        if isOnboarded {
            
                ZStack {
                    if self.isLoggedIn {
                        DashboardView()
                    } else {
                        LoginView()
                    }
                }.onAppear{
                    var handle = Auth.auth().addStateDidChangeListener{auth, user in if user != nil {
                            self.isLoggedIn = true
                    } else {
                        self.isLoggedIn = false
                    }}
                }
                
        } else {
            OnboardingView()
        }  
    }
}

#Preview {
    ContentView()
}

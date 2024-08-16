//
//  OnboardingScreen.swift
//  GameLogger
//
//  Created by Glen on 2024/07/26.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("isOnboarded") var isOnboarded = false
    
    var body: some View {
        ZStack{
        
            VStack{
                TabView{
                    OnboardingCardView(title: "Welcome", icon: "door.left.hand.open", description: "Welcome to stepper. The only fitness app you will ever need...").padding()
                    
                    OnboardingCardView(title: "Walk", icon: "figure.walk", description: "We need your permissions to track your steps please...").padding()
                    
                    OnboardingCardView(title: "Live", icon: "tree", description: "You also need to sign up to firestore please...for the love of walking...").padding()
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                
                NavigationLink(destination: LoginView()){
                    Button(action: {
                        isOnboarded.toggle()
                    }){
                        HStack{
                            Text("Finish")
                                .padding()
                                .bold()
                                .foregroundColor(Color.blue)
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                                .padding()
                        }
                    }
                    .background(Color.white)
                    .padding()
                    
                }

            }//END Vstack
        }.background(Color.gray)
        
            .ignoresSafeArea(.all)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}


import SwiftUI

struct SignupView: View {
    
    @State public var name: String = ""
    
    @ObservedObject var firebaseAuthManager = FirebaseAuthManager()
    
    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                
                TextField("Name", text: $firebaseAuthManager.name)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .autocapitalization(UITextAutocapitalizationType.words)
                    .padding()

                TextField("Email", text: $firebaseAuthManager.email)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()

                SecureField("Password", text: $firebaseAuthManager.password)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding()

                Button(action: {
                    firebaseAuthManager.signup()
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .padding()

                NavigationLink(destination: LoginView()) {
                    Text("Already have an Account? Log In.")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
                .padding()
            }
            .cornerRadius(20)
            .background(Color.white)
            .padding(15)
            
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}



import SwiftUI

struct LoginView: View {
    
    @ObservedObject var firebaseAuthManager = FirebaseAuthManager()

    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Log In")
                    .font(.title)
                    .fontWeight(.semibold)
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
                    firebaseAuthManager.login()
                }) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .padding()

                NavigationLink(destination: SignupView()) {
                    Text("Dont have an account? Sign up")
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

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

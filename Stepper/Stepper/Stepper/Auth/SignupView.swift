import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            Color(hex: "#DAE1E7")
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 30)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)

                Button(action: {
                    // Handle sign-up 
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                NavigationLink(destination: LoginView()) {
                    Text("Already have an Account? Log In.")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
            }
            .padding()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

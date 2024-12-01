//
//  AuthView.swift
//  Notes
//
//  Created by Joseph Smith on 11/17/24.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = Auth.auth().currentUser != nil
    @State private var errorDescription = ""

    var body: some View {
        if isSignedIn {
            ContentView()
        } else {
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    
                    Text("Welcome to Productivity Hub")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    
                    VStack(spacing: 20) {
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // Sign In Button
                    Button("Sign In") {
                        signIn()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)

                    // Sign Up Button
                    Button("Sign Up") {
                        signUp()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)

                    // Error Description
                    if !errorDescription.isEmpty {
                        Text(errorDescription)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 10)
                    }
                }
                .padding()
            }
        }
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error { // Next update - change error to give different response per error caught
                errorDescription = "Username and password combination do not match, or no user for this email address. Please sign up to continue."
            } else {
                isSignedIn = true
                errorDescription = ""
            }
        }
    }

    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorDescription = error.localizedDescription
            } else {
                isSignedIn = true
            }
        }
    }
}

#Preview {
    AuthView()
}


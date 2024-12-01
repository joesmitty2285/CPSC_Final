//
//  SettingsView.swift
//  Productivity
//
//  Created by Joseph Smith on 11/30/24.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @State private var userEmail: String = Auth.auth().currentUser?.email ?? "Unknown"
    @State private var lastLogin: String = "Unavailable"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // User Email
                HStack {
                    Text("Email:")
                        .font(.headline)
                    Spacer()
                    Text(userEmail)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Last Login Time
                HStack {
                    Text("Last Login:")
                        .font(.headline)
                    Spacer()
                    Text(lastLogin)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Sign Out Button
                Button(action: {
                    do {
                        try Auth.auth().signOut()
                        // Navigate back to AuthView
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.rootViewController = UIHostingController(rootView: AuthView())
                            window.makeKeyAndVisible()
                        }
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 40)
            .navigationTitle("Settings")
            .onAppear {
                fetchLastLogin()
            }
        }
    }
    
    // Fetch the last login time 
    private func fetchLastLogin() {
        if let user = Auth.auth().currentUser {
            if let metadata = user.metadata.lastSignInDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                lastLogin = formatter.string(from: metadata)
            }
        }
    }
}

#Preview {
    SettingsView()
}


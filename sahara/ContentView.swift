//
//  ContentView.swift
//  sahara
//
//  Created by Alec Perez-Ibanez on 10/10/24.
//

import SwiftUI

@main
struct SaharaApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView() // Sahara Request Page if logged in
            } else {
                SignInView() // Sign In page otherwise
            }
        }
    }
}

// Sign-In View
struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword = false
    @State private var showCreateAccount = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var userAccounts: [String: String] = [:]

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Sign In")
                        .font(.largeTitle)
                        .foregroundColor(.white)

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .autocapitalization(.none)

                    HStack {
                        if showPassword {
                            TextField("Password", text: $password)
                                .foregroundColor(.white)
                        } else {
                            SecureField("Password", text: $password)
                                .foregroundColor(.white)
                        }

                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)

                    Button("Sign In") {
                        signIn()
                    }
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .foregroundColor(.black)

                    Button("Create New Account") {
                        showCreateAccount = true
                    }
                    .foregroundColor(.yellow)
                    .padding()

                    NavigationLink(destination: CreateAccountView(userAccounts: $userAccounts), isActive: $showCreateAccount) {
                        EmptyView()
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }

    private func signIn() {
        if let storedPassword = userAccounts[email], storedPassword == password {
            isLoggedIn = true
        } else {
            print("Invalid email or password")
        }
    }
}

// Create Account View
struct CreateAccountView: View {
    @Binding var userAccounts: [String: String]
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .autocapitalization(.none)

                HStack {
                    if showPassword {
                        TextField("Password", text: $password)
                            .foregroundColor(.white)
                    } else {
                        SecureField("Password", text: $password)
                            .foregroundColor(.white)
                    }

                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)

                Button("Create Account") {
                    createAccount()
                }
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
                .foregroundColor(.black)
            }
            .padding()
        }
        .navigationBarHidden(true)
    }

    private func createAccount() {
        if !email.isEmpty && !password.isEmpty {
            userAccounts[email] = password
            isLoggedIn = true
        } else {
            print("Please enter a valid email and password")
        }
    }
}

// Sahara Request Page
struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true
    @State private var requestText: String = ""
    @State private var history: [String] = []
    @State private var hasSubmittedRequest = false
    @State private var suggestions: [String] = []
    @State private var showingSettings = false // New state variable for Settings view
    let allSuggestions: [[String]] = [
        ["What are the best retirement plans?", "How can I diversify my investments?", "What is the best way to start saving for a house?"],
        ["How should I manage my debt?", "Should I invest in mutual funds or ETFs?", "What are the risks of investing in stocks?"],
        ["How can I improve my credit score?", "What are the best budgeting tips?", "How do I start an emergency fund?"],
        ["What should I know about life insurance?", "How do I create a sustainable budget?", "When is the right time to invest in real estate?"]
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        showingSettings.toggle() // This will now open the Settings view
                    }) {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .padding(.top, 10) // Keep this for vertical alignment
                    .padding(.leading, 25) // Adjust this to move it left, you can increase or decrease the value as needed

                    Spacer()
                }

                Text("Sahara")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, -20) // You can adjust this value if needed
                    .padding(.leading, 10) // Align with the button

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            ForEach(history.indices, id: \.self) { index in
                                HStack {
                                    Spacer()
                                    Text(history[index])
                                        .padding()
                                        .background(Color.gray.opacity(0.7))
                                        .cornerRadius(15)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .id(index)
                            }
                        }
                        .onChange(of: history) { _ in
                            if let lastRequestIndex = history.indices.last {
                                withAnimation {
                                    proxy.scrollTo(lastRequestIndex, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                .padding()

                ZStack {
                    // Background for the request bar
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.1)) // Background color with opacity
                        .frame(height: 50) // Height of the request bar
                        .padding(.horizontal) // Add horizontal padding for spacing

                    HStack {
                        TextField("Requests Go Here", text: $requestText)
                            .padding(.leading, 40) // Padding inside the TextField
                            .foregroundColor(.white) // Text color
                            .frame(maxWidth: .infinity) // Make it expand to fill available space

                        Button(action: {
                            submitRequest()
                        }) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold)) // Thicker checkmark symbol
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.yellow)
                                .clipShape(Circle())
                                .frame(width: 25, height: 25) // Size of the circle
                                .padding(.trailing, 10) // Space from the right edge
                        }
                    }
                    .padding(.horizontal, 10) // Add padding to the sides of the HStack
                }
                .padding(.horizontal, -2) // Overall padding for the ZStack
                
                if !hasSubmittedRequest {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(suggestions, id: \.self) { suggestion in
                                Text(suggestion)
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        requestText = suggestion
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear(perform: refreshSuggestions)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingSettings) { // This will show the Settings view when the button is tapped
            SettingsView()
        }
    }

    private func submitRequest() {
        if !requestText.isEmpty {
            history.append(requestText)
            requestText = ""
            hasSubmittedRequest = true
        }
    }

    private func refreshSuggestions() {
        suggestions = allSuggestions.randomElement() ?? []
        history.removeAll()
    }
}
// Settings View
struct SettingsView: View {
    // Mock data for account information
    @State private var email: String = "user@example.com"
    
    var body: some View {
        VStack {
            // Settings title, same style as Sahara title
            Text("Settings")
                .font(.system(size: 36, weight: .bold)) // Same size and font as Sahara title
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.leading, 20)

            Spacer()
            
            // Account Info Section
            VStack(alignment: .leading, spacing: 15) {
                Text("Account Information")
                    .font(.headline)
                    .padding(.leading, 10)
                
                // Email Information
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 50)
                    .overlay(
                        HStack {
                            Text("Email: \(email)")
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                            Spacer()
                        }
                    )
                    .padding(.horizontal)
            }
            .padding(.top, 40)
            
            // Section for Change Password and Logout
            VStack(alignment: .leading, spacing: 15) {
                Text("Account Options")
                    .font(.headline)
                    .padding(.leading, 10)
                
                // Change Password Button
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 50)
                    .overlay(
                        HStack {
                            Text("Change Password")
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                            Spacer()
                        }
                    )
                    .padding(.horizontal)
                
                // Log Out Button
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 50)
                    .overlay(
                        HStack {
                            Text("Log Out")
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                            Spacer()
                        }
                    )
                    .padding(.horizontal)
            }
            .padding(.top, 30)

            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Background color
        .foregroundColor(.white) // Text color
    }
}

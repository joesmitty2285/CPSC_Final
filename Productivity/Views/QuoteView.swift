//
//  QuoteView.swift
//  Productivity
//
//  Created by Joseph Smith on 11/30/24.
//

import SwiftUI

struct QuoteView: View {
    @StateObject private var viewModel = QuoteViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let quote = viewModel.quote {
                    Text("\"\(quote.q)\"")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("- \(quote.a)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text("No quote available")
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    viewModel.fetchRandomQuote()
                }) {
                    Text("Get Another Quote")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchRandomQuote() // Fetch a quote on load
            }
            .navigationTitle("Motivation")
        }
    }
}

#Preview {
    QuoteView()
}

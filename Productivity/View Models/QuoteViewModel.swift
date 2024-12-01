//
//  QuoteViewModel.swift
//  Productivity
//
//  Created by Joseph Smith on 11/30/24.
//

import Foundation

class QuoteViewModel: ObservableObject {
    @Published var quote: Quote? // The current quote
    @Published var isLoading = false // Loading state
    
    func fetchRandomQuote() {
        guard let url = URL(string: "https://zenquotes.io/api/random") else { return }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                print("Error fetching quote: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedQuotes = try JSONDecoder().decode([Quote].self, from: data)
                DispatchQueue.main.async {
                    self.quote = decodedQuotes.first 
                }
            } catch {
                print("Error decoding quote: \(error)")
            }
        }.resume()
    }
}


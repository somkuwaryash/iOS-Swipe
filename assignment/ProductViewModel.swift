//
//  ProductViewModel.swift
//  assignment
//
//  Created by Yash Somkuwar on 07/10/23.
//

import Foundation

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    //filtering by search text
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        }
        else {
            return products.filter { $0.productName.contains(searchText) }
        }
    }
    
    // fetch from API
    func fetchProducts() {
        isLoading = true
        guard let url = URL(string: "https://app.getswipe.in/api/public/get")
        else{
            print("Invalid API")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error ) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedProducts = try decoder.decode([Product].self, from: data)
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        self?.products = decodedProducts
                    }
                }
                catch {
                    print("Error while decoding data: \(error)")
                }
            }
        }
        task.resume()
    }
}

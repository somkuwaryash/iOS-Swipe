//
//  ProductListView.swift
//  assignment
//
//  Created by Yash Somkuwar on 07/10/23.
//

import SwiftUI

struct ProductListView: View {
    @ObservedObject var viewModel = ProductViewModel()
    @State private var showAddProductView: Bool = false //flag for display of addProductView
    
    var body: some View {
        NavigationView {
            VStack {
                //search bar
                SearchBar(text: $viewModel.searchText, placeholder: "Search products")
                
                //loading screen
                if viewModel.isLoading {
                    ProgressView()
                        .rotationEffect(Angle(degrees: viewModel.isLoading ? 360 : 0))
                        .padding(.top, 50)
                } else {
                    ScrollView {
                        ForEach(viewModel.filteredProducts) { product in
                            ProductRow(product: product)
                        }
                    }
                }

                Spacer()
                
                //button for addPRoductView
                Button(action: {
                    showAddProductView = true
                }) {
                    Text("Add Product")
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.bottom, 20)

            }
            .onAppear() {
                viewModel.fetchProducts()
            }
            .background(Color.background.ignoresSafeArea())
            .navigationBarTitle("Products", displayMode: .inline)
            .sheet(isPresented: $showAddProductView) {
                AddProductView()
            }
        }
    }
}

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack {
            // display image if available otherwise fill with default
            if let url = URL(string: product.image), !product.image.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "photo.fill")
                    case .success(let image):
                        image
                    case .failure:
                        Image(systemName: "bag.fill")
                    @unknown default:
                        Image(systemName: "bag.fill")
                    }
                }
                .scaledToFit()
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            }
            else {
                Image(systemName: "bag.fill")
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
            }
            VStack(alignment: .leading, spacing: 5) {
                //product details
                Text(product.productName)
                    .font(.headline)
                    .foregroundColor(Color.primaryText)
                
                Text("\(product.price)")
                    .font(.subheadline)
                    .foregroundColor(Color.secondaryText)
            }
            .padding(.leading, 10)
            
            Spacer()
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

//Color Scheme
extension Color {
    static let background = Color(red: 235/255, green: 235/255, blue: 240/255)
    static let cardBackground = Color.white
    static let primaryText = Color(red: 20/255, green: 20/255, blue: 20/255)
    static let secondaryText = Color(red: 80/255, green: 80/255, blue: 80/255)
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}

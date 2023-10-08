//
//  Product.swift
//  assignment
//
//  Created by Yash Somkuwar on 07/10/23.
//

import Foundation

struct Product: Identifiable, Decodable {
    //unique identifier
    var id: String { productName }
    
    let image: String
    let price: Double
    let productName: String
    let productType: String
    let tax: Double
    
    //coding keys for mapping JSON to var
    enum CodingKeys: String, CodingKey {
        case image
        case price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}

struct APIResponse: Decodable {
    var results: [Product]
}


/// for adding new products

struct newProduct: Encodable {
    var productName: String
    var productType: String
    var price: Double
    var tax: Double
    var imageData: Data?
}

struct ResponseObject: Decodable {
    let message: String?
    let productDetails: ProductDetails?
    let productId: Int?
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case message
        case productDetails = "product_details"
        case productId = "product_id"
        case success
    }
}

struct ProductDetails: Decodable {
    let image: String?
    let price: Double?
    let productName: String?
    let productType: String?
    let tax: Double?
    
    enum CodingKeys: String, CodingKey {
        case image
        case price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}

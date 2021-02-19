//
//  Product.swift
//  ProEdu
//
//  Created by Raz  on 16.12.20.
//

import Foundation

struct ProductsResult: Decodable {
    let count: Int?
    let products: [Product]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case products = "results"
    }
}

struct Product: Codable {
    let id: Int?
    let detail: ProductDetail?
    let breakfast, lunch, snack, dinner: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case detail = "product"
        case breakfast, lunch, snack, dinner
    }
}

struct ProductDetail: Codable {
    let title, description: String?
}

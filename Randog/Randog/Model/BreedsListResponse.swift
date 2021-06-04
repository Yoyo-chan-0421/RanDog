//
//  BreedsListResponse.swift
//  Randog
//
//  Created by YoYo on 2021-06-04.
//

import Foundation
struct BreedsListResponse: Codable {
    let status: String
    let message: [String: [String]]
}

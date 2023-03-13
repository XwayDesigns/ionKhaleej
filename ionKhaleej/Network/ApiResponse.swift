//
//  ApiResponse.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 14/03/23.
//

import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let error: String?
    let data: T?
}

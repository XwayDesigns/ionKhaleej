//
//  AppError.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 14/03/23.
//

import Foundation

enum AppError: LocalizedError {
    case errorDecoding
    case unknownError
    case invalidUrl
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
            
        case .errorDecoding:
            return "Response could not be decoded"
        case .unknownError:
            return "Unknown error"
        case .invalidUrl:
            return "Url invalid"
        case .serverError(let error):
            return error
        }
    }
}

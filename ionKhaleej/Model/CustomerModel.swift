//
//  CustomerModel.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 17/04/23.
//

import Foundation

struct CustomerModel: Decodable{
    let customer_name: String?
    let customer_name_ar: String?
    let logo: String?
    let email: String?
    let mobile: String?
    let disclaimer: String?
    let disclaimer_ar: String?
    let about: String?
    let about_ar: String?
    let terms: String?
    let terms_ar: String?
    let privacy: String?
    let privacy_ar: String?
}

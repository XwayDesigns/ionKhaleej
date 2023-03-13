//
//  String+Extension.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 14/03/23.
//

import Foundation

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
}

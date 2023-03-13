//
//  Route.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 14/03/23.
//

import Foundation

enum Route {
    static let baseurl = "http://194.126.33.83/gscustomers/ios/"
    
    case logo
    case channels
    
    var description: String {
        switch self {
        case .logo: return "logo.php"
        case .channels: return "channels.php"
        }
    }
}

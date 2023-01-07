//
//  Model.swift
//  ios_assignment
//
//  Created by Shubham Kushwaha on 07/01/23.
//

import Foundation

struct Response: Decodable {
    var success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
    }
}

//
//  User.swift
//  
//
//  Created by Andreas Osberghaus on 2024-02-14.
//

import Foundation

public struct User: Decodable {
    public let id: String
    public let phoneNumber: String
    public let details: Details
    public let fields: [Field]
    
    enum CodingKeys: String, CodingKey {
        case id
        case phoneNumber
        case details
        case fields = "detailFields"
    }
    
    public struct Details: Codable {
        public let firstName: String?
        public let lastName: String?
        public let email: String?
    }
    
    public struct Field: Decodable {
        public let id: String
        public let isRequired: Bool
        
        enum CodingKeys: String, CodingKey {
            case id
            case isRequired = "required"
        }
    }
}

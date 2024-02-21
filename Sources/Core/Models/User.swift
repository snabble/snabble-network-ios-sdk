//
//  User.swift
//  
//
//  Created by Andreas Osberghaus on 2024-02-14.
//

import Foundation

public struct User: Decodable, Identifiable {
    public let id: String
    public let phoneNumber: String?
    public let details: Details
    public let fields: [Field]
    
    enum CodingKeys: String, CodingKey {
        case id
        case phoneNumber
        case details
        case fields = "detailFields"
    }
    
    public struct Details: Codable, Equatable {
        public let firstName: String?
        public let lastName: String?
        public let email: String?
        
        public init(firstName: String?, lastName: String?, email: String?) {
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
        }
    }
    
    public struct Field: Decodable, Identifiable, Equatable {
        public let id: String
        public let isRequired: Bool
        
        enum CodingKeys: String, CodingKey {
            case id
            case isRequired = "required"
        }
    }
}

extension User: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

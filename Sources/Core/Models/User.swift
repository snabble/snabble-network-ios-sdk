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
    public let details: Details?
    public let fields: [Field]?
    public let consent: Consent?

    enum CodingKeys: String, CodingKey {
        case id
        case phoneNumber
        case details
        case fields = "detailFields"
        case consent = "currentConsent"
    }

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.details = try container.decodeIfPresent(Details.self, forKey: .details)
        self.fields = try container.decodeIfPresent([Field].self, forKey: .fields)
        self.consent = try container.decodeIfPresent(Consent.self, forKey: .consent)
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

    public struct Consent: Decodable, Equatable {
        public let major: Int
        public let minor: Int
        
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.major < rhs.major
        }
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.major == rhs.major && lhs.minor == rhs.minor
        }
    }
}

extension User: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

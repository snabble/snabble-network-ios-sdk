//
//  ClientError.swift
//
//
//  Created by Uwe Tilemann on 20.02.24.
//

import Foundation

public struct ClientError: Decodable {
    public let error: ErrorType
    
    public struct ErrorType: Decodable {
        let type: String
        let message: String
    }
}

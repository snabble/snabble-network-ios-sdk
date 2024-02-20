//
//  ClientError.swift
//
//
//  Created by Uwe Tilemann on 20.02.24.
//

import Foundation

public struct ClientError: Decodable {
    public let type: String
    public let message: String
}

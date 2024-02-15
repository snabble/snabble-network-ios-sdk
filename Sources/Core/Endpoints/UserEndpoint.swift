//
//  UserEndpoint.swift
//  
//
//  Created by Andreas Osberghaus on 2024-02-15.
//

import Foundation

extension Endpoints {
    enum User {
        public static func me(configuration: Configuration) -> Endpoint<SnabbleNetwork.User> {
            return .init(
                path: "/apps/users/me",
                method: .get(nil),
                configuration: configuration,
                parse: { data in
                    try Endpoints.jsonDecoder.decode(SnabbleNetwork.User.self, from: data)
                }
            )
        }
        
        public static func update(configuration: Configuration, details: SnabbleNetwork.User.Details) -> Endpoint<Void> {
            return .init(
                path: "/apps/users/me/details",
                method: .put(try? Endpoints.jsonEncoder.encode(details)),
                configuration: configuration,
                parse: { _ in
                    return ()
                }
            )
        }
        
        public static func erase(configuration: Configuration) -> Endpoint<Void> {
            return .init(
                path: "/apps/users/me/erase",
                method: .post(nil, nil),
                configuration: configuration,
                parse: { _ in
                    return ()
                }
            )
        }
    }
}

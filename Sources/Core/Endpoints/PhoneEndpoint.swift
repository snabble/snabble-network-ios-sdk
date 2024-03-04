//
//  PhoneEndpoint.swift
//  
//
//  Created by Andreas Osberghaus on 2023-05-03.
//

import Foundation

extension Endpoints {
    public enum Phone {
        public static func auth(appId: String, phoneNumber: String) -> Endpoint<Void> {
            // swiftlint:disable:next force_try
            let data = try! JSONSerialization.data(withJSONObject: [
                "phoneNumber": phoneNumber
            ])
            return .init(
                path: "/\(appId)/me/verification/phone-number",
                method: .post(data),
                parse: { _ in
                    return ()
                }
            )
        }

        public static func login(appId: String, phoneNumber: String, OTP: String) -> Endpoint<SnabbleNetwork.AppUser?> {
            // swiftlint:disable:next force_try
            let data = try! JSONSerialization.data(withJSONObject: [
                "otp": OTP,
                "phoneNumber": phoneNumber
            ])
            return .init(
                path: "/\(appId)/me/verification/phone-number/otp",
                method: .post(data),
                parse: { data in
                    do {
                        return try Endpoints.jsonDecoder.decode(SnabbleNetwork.AppUser.self, from: data)
                    } catch {
                        if case DecodingError.keyNotFound(let codingKey, _) = error {
                            if codingKey.stringValue == "secret" {
                                return nil
                            }
                        }
                        if data.isEmpty {
                            return nil
                        }
                        throw error
                    }
                })
        }

        public static func delete(appId: String, phoneNumber: String) -> Endpoint<Void> {
            return .init(
                path: "/\(appId)/me/phone-number",
                method: .delete,
                parse: { _ in
                    return ()
                }
            )
        }
    }
}

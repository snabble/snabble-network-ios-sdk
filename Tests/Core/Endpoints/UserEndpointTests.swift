//
//  UserEndpointTests.swift
//  
//
//  Created by Andreas Osberghaus on 2024-02-16.
//

import XCTest
@testable import SnabbleNetwork

final class UserEndpointTests: XCTestCase {

    let phoneNumber = "+491771234567"
    let otp = "123456"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    var configuration: Configuration = .init(appId: "1", appSecret: "2", domain: .production, projectId: "1")
    var appUser: AppUser = .init(id: "555", secret: "123-456-789")

    func testMe() throws {
        let endpoint = Endpoints.User.me(configuration: configuration)
        XCTAssertEqual(endpoint.configuration, configuration)
        XCTAssertEqual(endpoint.domain, .production)
        XCTAssertEqual(endpoint.method.value, "GET")
        XCTAssertEqual(endpoint.path, "/apps/users/me")
        XCTAssertNil(endpoint.token)
        let urlRequest = try endpoint.urlRequest()
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://api.snabble.io/apps/users/me")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
    }

    func testUpdate() throws {
        let details = User.Details(firstName: "Foo", lastName: "Bar", email: "foo@bar.com")
        let endpoint = Endpoints.User.update(configuration: configuration, details: details)
        XCTAssertEqual(endpoint.configuration, configuration)
        XCTAssertEqual(endpoint.domain, .production)
        XCTAssertEqual(endpoint.method.value, "PUT")
        XCTAssertEqual(endpoint.path, "/apps/users/me/details")
        XCTAssertNil(endpoint.token)
        let urlRequest = try endpoint.urlRequest()
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://api.snabble.io/apps/users/me/details")
        XCTAssertEqual(urlRequest.httpMethod, "PUT")

        let data = try! JSONSerialization.data(withJSONObject: [
            "firstName": "Foo",
            "lastName": "Bar",
            "email": "foo@bar.com"
        ])
        XCTAssertEqual(urlRequest.httpBody?.count, data.count)
    }

    func testDelete() throws {
        let endpoint = Endpoints.User.erase(configuration: configuration)
        XCTAssertEqual(endpoint.configuration, configuration)
        XCTAssertEqual(endpoint.domain, .production)
        XCTAssertEqual(endpoint.method.value, "POST")
        XCTAssertEqual(endpoint.path, "/apps/users/me/erase")
        XCTAssertNil(endpoint.token)
        let urlRequest = try endpoint.urlRequest()
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://api.snabble.io/apps/users/me/erase")
        XCTAssertEqual(urlRequest.httpMethod, "POST")
    }

}

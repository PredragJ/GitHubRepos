//
//  CompositionRootTests.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 25. 11. 2025..
//

import XCTest
@testable import GitHubRepos

@MainActor
final class CompositionRootTests: XCTestCase {
    
    func test_CompositionRoot_usesGitHubAPIMock() async throws {
        let root = TestCompositionRoot()
        let viewController = root.makeRoot()
        
        let nav = viewController as! UINavigationController
        
        let expectation = XCTestExpectation(description: "Wait for mock data to load")
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 2)
        XCTAssertTrue(root.mockAPI != nil, "API should be GitHubAPIMock")
    }
}

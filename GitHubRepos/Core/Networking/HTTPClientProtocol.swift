//
//  HTTPClientProtocol.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 25. 11. 2025..
//

import Foundation

protocol HTTPClientProtocol {
    func get<T: Decodable>(_ url: URL) async throws -> T
}

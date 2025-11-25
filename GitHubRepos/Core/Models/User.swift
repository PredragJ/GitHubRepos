//
//  User.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import Foundation

struct User: Decodable {
    let login: String
    let avatarUrl: URL?
}

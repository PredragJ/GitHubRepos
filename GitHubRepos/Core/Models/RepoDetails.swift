//
//  RepoDetails.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import Foundation

struct RepoDetails: Decodable {
    let id: Int
    let name: String
    let owner: User
    let forksCount: Int
    let watchersCount: Int
    let description: String?
}

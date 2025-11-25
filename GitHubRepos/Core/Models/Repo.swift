//
//  Repo.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import Foundation

struct Repo: Decodable {
    let id: Int
    let name: String
    let owner: User
    let openIssuesCount: Int
    let forksCount: Int
    let watchersCount: Int
}

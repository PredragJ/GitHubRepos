//
//  Tag.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import Foundation

struct Tag: Decodable {
    struct CommitRef: Decodable {
        let sha: String
        let url: URL?
    }
    let name: String
    let commit: CommitRef
}

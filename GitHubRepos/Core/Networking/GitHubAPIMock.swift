//
//  GitHubAPIMock.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import Foundation

struct GitHubAPIMock: GitHubAPIProtocol {
    var delay: UInt64 = 300_000_000 // 0.3s

    func userRepos(username: String) async throws -> [Repo] {
        try await Task.sleep(nanoseconds: delay)
        let user = User(login: username, avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/583231?v=4"))
        return [
            Repo(id: 1, name: "Hello-World", owner: user, openIssuesCount: 3, forksCount: 42, watchersCount: 100),
            Repo(id: 2, name: "Spoon-Knife", owner: user, openIssuesCount: 0, forksCount: 10, watchersCount: 50)
        ]
    }

    func repoDetails(owner: String, repo: String) async throws -> RepoDetails {
        try await Task.sleep(nanoseconds: delay)
        let user = User(login: owner, avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/583231?v=4"))
        return RepoDetails(id: 99, name: repo, owner: user, forksCount: 42, watchersCount: 100, description: "Mock description")
    }

    func repoTags(owner: String, repo: String) async throws -> [Tag] {
        try await Task.sleep(nanoseconds: delay)
        return [
            Tag(name: "v1.0.0", commit: .init(sha: "abc123", url: nil)),
            Tag(name: "v1.1.0", commit: .init(sha: "def456", url: nil)),
            Tag(name: "v2.0.0", commit: .init(sha: "789abc", url: nil))
        ]
    }
}

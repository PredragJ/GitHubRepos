//
//  GitHubAPI.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import Foundation

struct GitHubAPI: GitHubAPIProtocol {

    private let http: HTTPClientProtocol
    private let base = URL(string: "https://api.github.com")!

    init(httpClient: HTTPClientProtocol) {
        self.http = httpClient
    }

    func userRepos(username: String) async throws -> [Repo] {
        let url = base.appendingPathComponent("users").appendingPathComponent(username).appendingPathComponent("repos")
        return try await http.get(url) as [Repo]
    }

    func repoDetails(owner: String, repo: String) async throws -> RepoDetails {
        let url = base.appendingPathComponent("repos").appendingPathComponent(owner).appendingPathComponent(repo)
        return try await http.get(url) as RepoDetails
    }

    func repoTags(owner: String, repo: String) async throws -> [Tag] {
        let url = base.appendingPathComponent("repos").appendingPathComponent(owner).appendingPathComponent(repo).appendingPathComponent("tags")
        return try await http.get(url) as [Tag]
    }
}

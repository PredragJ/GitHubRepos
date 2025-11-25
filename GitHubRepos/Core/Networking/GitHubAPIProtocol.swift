//
//  GitHubAPIProtocol.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import Foundation

protocol GitHubAPIProtocol {
    func userRepos(username: String) async throws -> [Repo]
    func repoDetails(owner: String, repo: String) async throws -> RepoDetails
    func repoTags(owner: String, repo: String) async throws -> [Tag]
}

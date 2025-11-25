//
//  UserReposViewModel.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import Foundation

@MainActor
final class UserReposViewModel {

    struct Row {
        let name: String
        let openIssues: Int
        let owner: User
    }

    enum State {
        case idle
        case loading
        case loaded
        case error(String)
    }

    // MARK: - Dependencies

    private let username: String
    private let api: GitHubAPIProtocol

    // MARK: - Output for UI

    private(set) var rows: [Row] = []
    private(set) var state: State = .idle {
        didSet { onChange?(state) }
    }

    var onChange: ((State) -> Void)?

    // MARK: - Init

    init(username: String, api: GitHubAPIProtocol) {
        self.username = username
        self.api = api
    }

    // MARK: - Public API

    func load() async {
        state = .loading
        do {
            let repos = try await api.userRepos(username: username)

            rows = repos.map { repo in
                Row(
                    name: repo.name,
                    openIssues: repo.openIssuesCount,
                    owner: repo.owner
                )
            }

            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

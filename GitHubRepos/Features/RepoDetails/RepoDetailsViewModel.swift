//
//  RepoDetailsViewModel.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import Foundation

@MainActor
final class RepoDetailsViewModel {

    struct Header {
        let ownerName: String
        let ownerAvatarUrl: URL?
        let repoName: String
        let forks: Int
        let watchers: Int
    }

    struct TagRow {
        let name: String
        let sha: String
    }

    enum State {
        case idle
        case loading
        case loaded(Header, [TagRow])
        case error(String)
    }

    private let owner: String
    private let repo: String
    private let api: GitHubAPIProtocol

    private(set) var state: State = .idle {
        didSet { onChange?(state) }
    }
    var onChange: ((State) -> Void)?

    init(owner: String, repo: String, api: GitHubAPIProtocol) {
        self.owner = owner
        self.repo = repo
        self.api = api
    }

    func load() async {
        state = .loading
        do {
            async let detailsTask = api.repoDetails(owner: owner, repo: repo)
            async let tagsTask = api.repoTags(owner: owner, repo: repo)
            let (details, tags) = try await (detailsTask, tagsTask)

            let header = Header(ownerName: details.owner.login,
                                ownerAvatarUrl: details.owner.avatarUrl,
                                repoName: details.name,
                                forks: details.forksCount,
                                watchers: details.watchersCount)
            let rows = tags.map { TagRow(name: $0.name, sha: $0.commit.sha) }
            state = .loaded(header, rows)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

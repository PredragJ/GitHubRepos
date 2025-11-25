//
//  UserReposViewModelTests.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 25. 11. 2025..
//

import XCTest
@testable import GitHubRepos

@MainActor
final class UserReposViewModelTests: XCTestCase {

    // MARK: - Stub

    private final class GitHubAPIStub: GitHubAPIProtocol {
        var reposToReturn: [Repo] = []
        private(set) var capturedUsername: String?

        func userRepos(username: String) async throws -> [Repo] {
            capturedUsername = username
            return reposToReturn
        }

        func repoDetails(owner: String, repo: String) async throws -> RepoDetails {
            fatalError("repoDetails should not be called in this test")
        }

        func repoTags(owner: String, repo: String) async throws -> [Tag] {
            fatalError("repoTags should not be called in this test")
        }
    }

    // MARK: - Tests

    func test_load_populatesRowsFromAPI() async throws {
        let apiStub = GitHubAPIStub()

        let owner = User(
            login: "octocat",
            avatarUrl: URL(string: "https://example.com/avatar.png")
        )

        let repo = Repo(
            id: 1,
            name: "TestRepo",
            owner: owner,
            openIssuesCount: 7,
            forksCount: 42,
            watchersCount: 100
        )

        apiStub.reposToReturn = [repo]

        let viewModel = UserReposViewModel(
            username: "octocat",
            api: apiStub
        )

        await viewModel.load()

        XCTAssertEqual(apiStub.capturedUsername, "octocat")

        XCTAssertEqual(viewModel.rows.count, 1)

        let row = viewModel.rows[0]
        XCTAssertEqual(row.name, "TestRepo")
        XCTAssertEqual(row.openIssues, 7)
        XCTAssertEqual(row.owner.login, "octocat")
    }
    
    func test_load_setsErrorStateWhenAPIThrows() async {
        final class FailingAPIStub: GitHubAPIProtocol {
            func userRepos(username: String) async throws -> [Repo] { throw URLError(.badServerResponse) }
            func repoDetails(owner: String, repo: String) async throws -> RepoDetails { fatalError() }
            func repoTags(owner: String, repo: String) async throws -> [Tag] { fatalError() }
        }

        let viewModel = UserReposViewModel(username: "octocat", api: FailingAPIStub())

        await viewModel.load()

        if case .error(let message) = viewModel.state {
            XCTAssertTrue(message.contains("bad"), "Expected error message")
        } else {
            XCTFail("Expected .error state")
        }
    }
}

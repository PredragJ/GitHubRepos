//
//  TestCompositionRoot.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 25. 11. 2025..
//

import UIKit
@testable import GitHubRepos

@MainActor
final class TestCompositionRoot {

    private lazy var api: GitHubAPIProtocol = GitHubAPIMock()
    private lazy var imageLoader: ImageLoader = .shared
    private let navigationController = UINavigationController()
    private var coordinator: MainCoordinator?

    func makeRoot() -> UIViewController {
        let coordinator = MainCoordinator(navigationController: navigationController, api: api, imageLoader: imageLoader)
        self.coordinator = coordinator
        coordinator.start()
        return navigationController
    }

    var mockAPI: GitHubAPIMock? {
        api as? GitHubAPIMock
    }
}

//
//  UserReposCoordinator.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 25. 11. 2025..
//

import UIKit

final class MainCoordinator {
    
    private let navigationController: UINavigationController
        let api: GitHubAPIProtocol
        let imageLoader: ImageLoader

        init(navigationController: UINavigationController, api: GitHubAPIProtocol, imageLoader: ImageLoader) {
            self.navigationController = navigationController
            self.api = api
            self.imageLoader = imageLoader
        }

        func start() {
            let viewModel = UserReposViewModel(username: "octocat", api: api)
            let viewController = UserReposViewController(viewModel: viewModel) { [weak self] row in
                self?.showDetails(for: row)
            }

            navigationController.setViewControllers([viewController], animated: false)
        }

        private func showDetails(for row: UserReposViewModel.Row) {
            let detailsVM = RepoDetailsViewModel(owner: row.owner.login, repo: row.name, api: api)
            let detailsVC = RepoDetailsViewController(viewModel: detailsVM, imageLoader: imageLoader)

            navigationController.show(detailsVC, sender: nil)
        }
}

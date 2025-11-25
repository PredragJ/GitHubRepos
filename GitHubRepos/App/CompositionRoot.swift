//
//  CompositionRoot.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import UIKit

import UIKit

final class CompositionRoot {
    
    private lazy var httpClient: HTTPClient = HTTPClient()
    private lazy var api: GitHubAPIProtocol = GitHubAPI(httpClient: httpClient)
    private lazy var imageLoader: ImageLoader = .shared
    private let navigationController = UINavigationController()
    private var mainCoordinator: MainCoordinator?

    func makeRoot() -> UIViewController {
        let coordinator = MainCoordinator(navigationController: navigationController, api: api, imageLoader: imageLoader)
        self.mainCoordinator = coordinator
        coordinator.start()
        
        return navigationController
    }
    
}

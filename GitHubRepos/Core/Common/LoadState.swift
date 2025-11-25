//
//  LoadState.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import Foundation

enum LoadState<Value> {
    case idle
    case loading
    case loaded(Value)
    case error(String)
}

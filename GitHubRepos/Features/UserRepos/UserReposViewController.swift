//
//  UserReposViewController.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import UIKit

final class UserReposViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private let viewModel: UserReposViewModel
    private let onSelect: (UserReposViewModel.Row) -> Void
    
    // MARK: - UI
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Init
    
    init(
        viewModel: UserReposViewModel,
        onSelect: @escaping (UserReposViewModel.Row) -> Void
    ) {
        self.viewModel = viewModel
        self.onSelect = onSelect
        super.init(nibName: nil, bundle: nil)
        title = "Repositories"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupTableView()
        loadData()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(
            UserRepoCell.self,
            forCellReuseIdentifier: UserRepoCell.reuseID
        )
    }
    
    private func loadData() {
        Task { [weak self] in
            guard let self else { return }
            await self.viewModel.load()
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension UserReposViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = viewModel.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UserRepoCell.reuseID,for: indexPath) as! UserRepoCell
        
        cell.configure(with: row)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension UserReposViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = viewModel.rows[indexPath.row]
        onSelect(row)
    }
}

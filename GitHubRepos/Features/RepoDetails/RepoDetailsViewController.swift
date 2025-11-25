//
//  RepoDetailsViewController.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import UIKit

final class RepoDetailsViewController: UIViewController {

    // MARK: - Dependencies

    private let viewModel: RepoDetailsViewModel
    private let imageLoader: ImageLoader

    // MARK: - UI

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let headerView = RepoDetailsHeaderView()
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - State

    private var tagRows: [RepoDetailsViewModel.TagRow] = []

    // MARK: - Init

    init(viewModel: RepoDetailsViewModel, imageLoader: ImageLoader) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
        title = "Details"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupTableView()
        setupHeader()
        bindViewModel()

        Task { await viewModel.load() }
    }

    // MARK: - Setup

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TagCell.self, forCellReuseIdentifier: TagCell.reuseID)
    }

    private func setupHeader() {
        tableView.tableHeaderView = headerView
        headerView.frame.size.width = view.bounds.width
        headerView.layoutIfNeeded()
        headerView.sizeToFit()
        updateHeaderLayoutHeight()
    }

    // MARK: - ViewModel Binding

    private func bindViewModel() {
        viewModel.onChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle, .loading:
                showLoading()
            case .loaded(let header, let tags):
                hideLoading()
                applyLoaded(header: header, tags: tags)
            case .error(let message):
                hideLoading()
                presentError(message)
            }
        }
    }

    private func showLoading() {
        loadingIndicator.startAnimating()
        navigationItem.titleView = loadingIndicator
    }

    private func hideLoading() {
        navigationItem.titleView = nil
        loadingIndicator.stopAnimating()
    }

    private func applyLoaded(header: RepoDetailsViewModel.Header, tags: [RepoDetailsViewModel.TagRow]) {
        tagRows = tags

        headerView.configure(owner: header.ownerName, repo: header.repoName, forks: header.forks, watchers: header.watchers)

        updateHeaderLayoutHeight()
        tableView.reloadData()

        if let url = header.ownerAvatarUrl {
            Task { [weak self] in
                guard let self else { return }
                if let image = try? await self.imageLoader.loadImage(from: url) {
                    self.headerView.setAvatar(image)
                    self.updateHeaderLayoutHeight()
                }
            }
        }
    }

    // MARK: - Helpers

    private func updateHeaderLayoutHeight() {
        let targetSize = CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height)

        let height = headerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height

        var frame = headerView.frame
        guard frame.height != height else { return }

        frame.size.height = height
        headerView.frame = frame
        tableView.tableHeaderView = headerView
    }

    private func presentError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension RepoDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tagRows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TagCell.reuseID, for: indexPath) as! TagCell

        let row = tagRows[indexPath.row]
        cell.configure(name: row.name, sha: row.sha)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RepoDetailsViewController: UITableViewDelegate {
    
}

//
//  UserRepoCell.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import UIKit

final class UserRepoCell: UITableViewCell {
    static let reuseID = "UserRepoCell"

    private let nameLabel = UILabel()
    private let issuesLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        nameLabel.font = .preferredFont(forTextStyle: .body)
        issuesLabel.font = .preferredFont(forTextStyle: .subheadline)
        issuesLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [nameLabel, issuesLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with row: UserReposViewModel.Row) {
        nameLabel.text = row.name
        issuesLabel.text = "Open issues: \(row.openIssues)"
    }
}

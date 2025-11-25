//
//  TagCell.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 24. 11. 2025..
//

import UIKit

final class TagCell: UITableViewCell {
    static let reuseID = "TagCell"

    private let nameLabel = UILabel()
    private let shaLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLabel.font = .preferredFont(forTextStyle: .body)
        shaLabel.font = .preferredFont(forTextStyle: .caption1)
        shaLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [nameLabel, shaLabel])
        stack.axis = .vertical
        stack.spacing = 2
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

    func configure(name: String, sha: String) {
        nameLabel.text = name
        shaLabel.text = sha
    }
}

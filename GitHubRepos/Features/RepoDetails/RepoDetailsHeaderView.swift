//
//  RepoDetailsHeaderView.swift
//  GitHubRepos
//
//  Created by Predrag Jevtic on 25. 11. 2025..
//

import UIKit

final class RepoDetailsHeaderView: UIView {

    private let avatar = UIImageView()
    private let ownerLabel = UILabel()
    private let repoLabel = UILabel()
    private let forksLabel = UILabel()
    private let watchersLabel = UILabel()
    private let vstack = UIStackView()
    private let hstack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 28

        ownerLabel.font = .preferredFont(forTextStyle: .subheadline)
        ownerLabel.textColor = .secondaryLabel

        repoLabel.font = .preferredFont(forTextStyle: .title2)
        repoLabel.numberOfLines = 0

        forksLabel.font = .preferredFont(forTextStyle: .footnote)
        watchersLabel.font = .preferredFont(forTextStyle: .footnote)

        vstack.axis = .vertical
        vstack.spacing = 6
        vstack.translatesAutoresizingMaskIntoConstraints = false

        hstack.axis = .horizontal
        hstack.alignment = .center
        hstack.spacing = 12
        hstack.translatesAutoresizingMaskIntoConstraints = false

        vstack.addArrangedSubview(repoLabel)
        vstack.addArrangedSubview(ownerLabel)
        vstack.addArrangedSubview(forksLabel)
        vstack.addArrangedSubview(watchersLabel)

        hstack.addArrangedSubview(avatar)
        hstack.addArrangedSubview(vstack)

        addSubview(hstack)

        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 56),
            avatar.heightAnchor.constraint(equalToConstant: 56),

            hstack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            hstack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            hstack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            hstack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    func configure(owner: String, repo: String, forks: Int, watchers: Int) {
        ownerLabel.text = owner
        repoLabel.text = repo
        forksLabel.text = "Forks: \(forks)"
        watchersLabel.text = "Watchers: \(watchers)"
    }

    func setAvatar(_ image: UIImage) {
        avatar.image = image
    }

    override func sizeToFit() {
        super.sizeToFit()
        setNeedsLayout()
        layoutIfNeeded()
    }
}

//
//  SectionTitleSupplementaryView.swift
//  Pump It Up
//
//  Created by Mark Wong on 9/1/2022.
//

import UIKit

class SectionTitleSupplementaryView: UICollectionReusableView {
    let label = UILabel()
    static let reuseIdentifier = "title-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SectionTitleSupplementaryView {
    func configure() {
        label.alpha = 0.7
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .caption2).with(weight: .light)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(0)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}

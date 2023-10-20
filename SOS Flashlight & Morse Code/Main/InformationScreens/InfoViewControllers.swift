//
//  SOSViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 27/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

class SOSInfoViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1).with(weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SOS"
        label.textColor = .defaultText
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The fastest way to send an SOS. The front screen can also be used as the light source to signal an SOS. Use the bottom right button to switch between the front (screen) and rear (light) of the phone"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .defaultText
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height * 0.07)
        
        let image = UIImage(systemName: "bolt.fill", withConfiguration: config)
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .defaultText
        return imageView
    }()
    
    lazy var doneButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Close"
        config.baseBackgroundColor = .systemOrange
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDone), for: .touchDown)
        return button
    }()
    
    init(title: String, description: String, icon: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height * 0.07)
        let image = UIImage(systemName: icon, withConfiguration: config)
        self.imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        
        view.addSubview(descriptionLabel)
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(doneButton)

        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        imageView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

    }
    
    @objc func handleDone() {
        self.dismiss(animated: true)
    }
}

class MessageInfoViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1).with(weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SOS"
        label.textColor = .defaultText
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The fastest way to send an SOS. The front screen can also be used as the light source to signal an SOS. Use the bottom right button to switch between the front (screen) and rear (light) of the phone"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .defaultText
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height * 0.07)
        
        let image = UIImage(systemName: "bolt.fill", withConfiguration: config)
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .defaultText
        return imageView
    }()
    
    lazy var doneButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Close"
        config.baseBackgroundColor = .systemOrange
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDone), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        
        view.addSubview(descriptionLabel)
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(doneButton)

        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        imageView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

    }
    
    @objc func handleDone() {
        self.dismiss(animated: true)
    }
    
}

class ConversionViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1).with(weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SOS"
        label.textColor = .defaultText
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The fastest way to send an SOS. The front screen can also be used as the light source to signal an SOS. Use the bottom right button to switch between the front (screen) and rear (light) of the phone"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .defaultText
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height * 0.07)
        
        let image = UIImage(systemName: "bolt.fill", withConfiguration: config)
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .defaultText
        return imageView
    }()
    
    lazy var doneButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Close"
        config.baseBackgroundColor = .systemOrange
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDone), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        
        view.addSubview(descriptionLabel)
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(doneButton)

        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        imageView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

    }
    
    @objc func handleDone() {
        self.dismiss(animated: true)
    }
    
}

class ToolsViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1).with(weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tools"
        label.textColor = .defaultText
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The fastest way to send an SOS. The front screen can also be used as the light source to signal an SOS. Use the bottom right button to switch between the front (screen) and rear (light) of the phone"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .defaultText
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height * 0.07)
        
        let image = UIImage(systemName: "bolt.fill", withConfiguration: config)
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .defaultText
        return imageView
    }()
    
    lazy var doneButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Close"
        config.baseBackgroundColor = .systemOrange
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDone), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        
        view.addSubview(descriptionLabel)
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(doneButton)

        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        imageView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

    }
    
    @objc func handleDone() {
        self.dismiss(animated: true)
    }
    
}

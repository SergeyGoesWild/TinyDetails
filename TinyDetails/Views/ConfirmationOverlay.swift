//
//  ConfirmationOverlay.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 25/06/2025.
//

import SwiftUI

final class ConfirmationOverlay: UIView {
    var backgroundView: UIView!
    var titleLabel: UILabel!
    var emojiLabel: UILabel!
    var avatarImageView: UIImageView!
    var centralStackView: UIStackView!
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.2
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 100
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let path = Bundle.main.path(forResource: "EchoAndNarcissus_echo_av", ofType: "jpg") else {
            print("Item Image not found in ClickableArea")
            return
        }
        let currentImage = UIImage(contentsOfFile: path)
        avatarImageView.image = currentImage
        imageContainer.addSubview(avatarImageView)
        
        emojiLabel = UILabel()
        emojiLabel.text = "✅"
        emojiLabel.font = .systemFont(ofSize: 50, weight: .bold)
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(emojiLabel)
        
        titleLabel = UILabel()
        titleLabel.text = "Echo"
        titleLabel.font = .systemFont(ofSize: 40, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        centralStackView = UIStackView(arrangedSubviews: [imageContainer, titleLabel])
        centralStackView.axis = .vertical
        centralStackView.distribution = .fill
        centralStackView.alignment = .center
        centralStackView.spacing = 10
        centralStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(centralStackView)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageContainer.heightAnchor.constraint(equalToConstant: 200),
            imageContainer.widthAnchor.constraint(equalToConstant: 200),
            
            avatarImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            
            emojiLabel.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor, constant: 70),
            emojiLabel.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor, constant: 70),
            
            centralStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            centralStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
        ])
    }
}

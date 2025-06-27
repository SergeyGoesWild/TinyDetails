//
//  ConfirmationOverlay.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 25/06/2025.
//

import SwiftUI

final class ConfirmationOverlay: UIView {
    var commonContainer: UIView!
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
        commonContainer = UIView()
        commonContainer.translatesAutoresizingMaskIntoConstraints = false
        commonContainer.backgroundColor = .clear
        commonContainer.alpha = 1.0
        
        backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.0
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        emojiLabel = UILabel()
        emojiLabel.text = "✅"
        emojiLabel.font = .systemFont(ofSize: 50, weight: .bold)
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        addSubview(commonContainer)
        commonContainer.addSubview(backgroundView)
        commonContainer.addSubview(centralStackView)
        imageContainer.addSubview(avatarImageView)
        imageContainer.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            commonContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            commonContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            commonContainer.topAnchor.constraint(equalTo: topAnchor),
            commonContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundView.leadingAnchor.constraint(equalTo: commonContainer.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: commonContainer.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: commonContainer.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: commonContainer.bottomAnchor),
            
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
    
    func revealOverlay(completion: @escaping () -> Void) {
        emojiLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        emojiLabel.alpha = 0
        emojiLabel.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.3
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.emojiLabel.alpha = 1
        })
        
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5,
                       options: [.curveEaseInOut],
                       animations: {
            self.emojiLabel.transform = .identity
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.commonContainer.alpha = 0
                }, completion: { _ in
                    completion()
                    self.restoreStartingState()
                })
            }
        })
    }
    
    private func restoreStartingState() {
        commonContainer.alpha = 1.0
        backgroundView.alpha = 0.0
        emojiLabel.alpha = 0.0
    }
}

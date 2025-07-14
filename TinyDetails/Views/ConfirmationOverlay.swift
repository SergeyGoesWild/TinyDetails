//
//  ConfirmationOverlay.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 25/06/2025.
//

import UIKit

final class ConfirmationOverlay: UIView {
    private var commonContainer: UIView!
    private var backgroundView: UIView!
    private var titleLabel: UILabel!
    private var emojiLabel: UILabel!
    private var avatarImageView: UIImageView!
    private var centralStackView: UIStackView!
    
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
        
        emojiLabel = UILabel()
        emojiLabel.text = "✅"
        emojiLabel.font = .systemFont(ofSize: 50, weight: .bold)
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 40, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 1
        
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
            
            centralStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            centralStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            centralStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
        ])
    }
    
    func revealOverlay(completion: @escaping () -> Void) {
        emojiLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        emojiLabel.alpha = 0
        emojiLabel.isHidden = false
        backgroundView.alpha = 0
        
        UIView.animateKeyframes(
            withDuration: 2.0,
            delay: 0,
            options: [.calculationModeLinear],
            animations: { [weak self] in
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1/2.0) {
                    self?.backgroundView.alpha = 0.4
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.0/2.0) {
                    self?.emojiLabel.alpha = 1
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.8/2.0) {
                                // Nested spring animation
                                UIView.animate(
                                    withDuration: 0.4,
                                    delay: 0,
                                    usingSpringWithDamping: 0.4,
                                    initialSpringVelocity: 15,
                                    animations: { [weak self] in
                                        self?.emojiLabel.transform = .identity
                                    },
                                    completion: nil
                                )
                            }
                
                UIView.addKeyframe(withRelativeStartTime: 1.9/2.0, relativeDuration: 0.1/2.0) {
                    self?.commonContainer.alpha = 0
                }
            },
            completion: { [weak self] _ in
                self?.restoreStartingState()
                completion()
            }
        )
    }
    
    private func restoreStartingState() {
        commonContainer.alpha = 1.0
        backgroundView.alpha = 0.0
        emojiLabel.alpha = 0.0
    }
    
    func updateConfirmationOverlay(areaData: ClickableArea) {
        titleLabel.text = areaData.hintText
        guard let path = Bundle.main.path(forResource: areaData.avatarName, ofType: "jpg") else {
            print("Avatar not found (Confirmation Overlay) for area: \(areaData)")
            return
        }
        let currentImage = UIImage(contentsOfFile: path)
        avatarImageView.image = currentImage
    }
}

//
//  ConfirmationOverlay.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 25/06/2025.
//

import UIKit

final class TutorialOverlay: UIView {
    weak var delegate: TutorialDelegate?
    private var dispatchItem: DispatchWorkItem?
    
    private var title: String!
    private var hintText: String!
    private var iconName: String!
    
    private var commonContainer: UIView!
    private var backgroundView: UIView!
    private var titleLabel: UILabel!
    private var hintLabel: UILabel!
    private var emojiLabel: UILabel!
    private var iconImageView: UIImageView!
    private var centralStackView: UIStackView!
    
    init(delegate: TutorialDelegate, title: String, hintText: String, iconName: String) {
        self.delegate = delegate
        self.title = title
        self.hintText = hintText
        self.iconName = iconName
        
        super.init(frame: .zero)
        setupView()
        
        scheduleDismissal()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func scheduleDismissal() {
        dispatchItem?.cancel()
        dispatchItem = DispatchWorkItem { [weak self] in
            self?.leaveTutorial()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: dispatchItem!)
    }
    
    private func setupView() {
        commonContainer = UIView()
        commonContainer.translatesAutoresizingMaskIntoConstraints = false
        commonContainer.backgroundColor = .clear
        commonContainer.alpha = 1.0
        
        backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.9
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        let touchView = UIView()
        touchView.translatesAutoresizingMaskIntoConstraints = false
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        touchView.addGestureRecognizer(gestureRecogniser)
        touchView.isUserInteractionEnabled = true
        touchView.backgroundColor = .clear
        
        let config = UIImage.SymbolConfiguration(hierarchicalColor: .white)
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(systemName: iconName, withConfiguration: config)
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 1
        titleLabel.text = title
        
        hintLabel = UILabel()
        hintLabel.font = .systemFont(ofSize: 25, weight: .regular)
        hintLabel.textColor = .white
        hintLabel.textAlignment = .center
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.adjustsFontSizeToFitWidth = true
        hintLabel.minimumScaleFactor = 0.5
        hintLabel.lineBreakMode = .byTruncatingTail
        hintLabel.numberOfLines = 1
        hintLabel.text = hintText
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.backgroundColor = .clear
        
        centralStackView = UIStackView(arrangedSubviews: [iconImageView, spacer, titleLabel, hintLabel])
        centralStackView.axis = .vertical
        centralStackView.distribution = .fill
        centralStackView.alignment = .center
        centralStackView.spacing = 5
        centralStackView.translatesAutoresizingMaskIntoConstraints = false
        centralStackView.backgroundColor = .clear
        
        addSubview(commonContainer)
        commonContainer.addSubview(backgroundView)
        commonContainer.addSubview(centralStackView)
        commonContainer.addSubview(touchView)
        
        NSLayoutConstraint.activate([
            commonContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            commonContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            commonContainer.topAnchor.constraint(equalTo: topAnchor),
            commonContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundView.leadingAnchor.constraint(equalTo: commonContainer.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: commonContainer.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: commonContainer.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: commonContainer.bottomAnchor),
            
            touchView.leadingAnchor.constraint(equalTo: commonContainer.leadingAnchor),
            touchView.trailingAnchor.constraint(equalTo: commonContainer.trailingAnchor),
            touchView.topAnchor.constraint(equalTo: commonContainer.topAnchor),
            touchView.bottomAnchor.constraint(equalTo: commonContainer.bottomAnchor),
            
            centralStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            centralStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            centralStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            
            spacer.heightAnchor.constraint(equalToConstant: 30),
            spacer.widthAnchor.constraint(equalTo: centralStackView.widthAnchor),
            
            iconImageView.heightAnchor.constraint(equalToConstant: 100),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    @objc private func handleTap() {
        leaveTutorial()
    }
    
    private func leaveTutorial() {
        dispatchItem?.cancel()
        UIView.animate(withDuration: 0.3, animations: {
            self.commonContainer.alpha = 0
        }, completion: { [weak self] _ in
            self?.delegate?.leavingTutorial()
        })
    }
    
    deinit {
        print("Tutorial deallocated")
        dispatchItem?.cancel()
    }
}

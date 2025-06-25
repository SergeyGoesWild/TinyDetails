//
//  ConfirmationOverlay.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 25/06/2025.
//

import SwiftUI

final class ConfirmationOverlay: UIView {
    var backgroundView: UIView!
    var emojiLabel: UILabel!
    
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
        backgroundView.alpha = 0.6
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        emojiLabel = UILabel()
        emojiLabel.text = "👍"
        emojiLabel.font = .systemFont(ofSize: 72, weight: .bold)
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            emojiLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
        ])
    }
}

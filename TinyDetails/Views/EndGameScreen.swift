//
//  EndGameScreen.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 26/06/2025.
//
import UIKit

final class EndGameScreen: UIView {
    weak var delegate: EndGameDelegate?
    
    private var titleLabel: UILabel!
    private var additionalLabel: UILabel!
    private var backgroundView: UIView!
    private var imageView: UIImageView!
    private var restartButton: UIButton!
    
    init(delegate: EndGameDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 45, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.text = "Bravo!"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        additionalLabel = UILabel()
        additionalLabel.font = .systemFont(ofSize: 18, weight: .thin)
        additionalLabel.numberOfLines = 0
        additionalLabel.textAlignment = .center
        additionalLabel.textColor = .white
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.text =
        """
        You finished the game in style!
        Soon there will be updates and new puzzles,
        so keep an eye on those.
        Until we meet again in "Tiny Details"!
        """
        
        restartButton = UIButton(type: .system)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let restartImage = UIImage(systemName: "arrow.clockwise.circle", withConfiguration: config)
        restartButton.setImage(restartImage, for: .normal)
        restartButton.tintColor = .white
        restartButton.addTarget(self, action: #selector(restartTapped), for: .touchUpInside)
        
        guard let path = Bundle.main.path(forResource: "finalScreenOsteria", ofType: "png") else {
            print("Final screen image not found")
            return
        }
        
        let currentImage = UIImage(contentsOfFile: path)
        
        imageView = UIImageView()
        imageView.image = currentImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.isUserInteractionEnabled = false
        spacer.backgroundColor = .clear
        
        addSubview(backgroundView)
        addSubview(spacer)
        addSubview(titleLabel)
        addSubview(additionalLabel)
        addSubview(restartButton)
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            spacer.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            spacer.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            spacer.widthAnchor.constraint(equalTo: backgroundView.widthAnchor),
            spacer.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.17),
            
            titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: spacer.bottomAnchor),
            
            additionalLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            additionalLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            
            restartButton.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 30),
            restartButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            restartButton.widthAnchor.constraint(equalToConstant: 50),
            restartButton.heightAnchor.constraint(equalToConstant: 50),
            
            imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: 0),
            imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 200),
            imageView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 1.2),
            imageView.heightAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 1.2),
        ])
    }
    
    @objc private func restartTapped() {
        delegate?.restartGame()
    }
}

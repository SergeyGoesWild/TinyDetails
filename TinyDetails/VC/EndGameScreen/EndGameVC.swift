//
//  EndGameScreen.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 26/06/2025.
//
import UIKit

final class EndGameScreen: UIViewController {
    var dataItem: EndGameData {
        get {
            return endGamePresenter.provideItem()
        }
    }
    
    var endGamePresenter: EndGamePresenter!
    
    private var titleLabel: UILabel!
    private var additionalLabel: UILabel!
    private var backgroundView: UIView!
    private var imageView: UIImageView!
    private var restartButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        endGamePresenter.onAppear()
    }
    
    private func setupUI() {
        backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 45, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.text = dataItem.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        additionalLabel = UILabel()
        additionalLabel.font = .systemFont(ofSize: 18, weight: .thin)
        additionalLabel.numberOfLines = 0
        additionalLabel.textAlignment = .center
        additionalLabel.textColor = .white
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.text = dataItem.endText
        restartButton = UIButton(type: .system)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let restartImage = UIImage(systemName: "arrow.clockwise.circle", withConfiguration: config)
        restartButton.setImage(restartImage, for: .normal)
        restartButton.tintColor = .white
        restartButton.addTarget(self, action: #selector(restartTapped), for: .touchUpInside)
        
        guard let path = Bundle.main.path(forResource: dataItem.imageName, ofType: dataItem.imageType) else {
            print("Final screen image not found")
            return
        }
        
        let currentImage = UIImage(contentsOfFile: path)
        
        imageView = UIImageView()
        imageView.image = currentImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViewContainer = UIView()
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        imageViewContainer.clipsToBounds = true
        imageViewContainer.isUserInteractionEnabled = false
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.isUserInteractionEnabled = false
        spacer.backgroundColor = .clear
        
        view.addSubview(backgroundView)
        view.addSubview(spacer)
        view.addSubview(titleLabel)
        view.addSubview(additionalLabel)
        view.addSubview(restartButton)
        view.addSubview(imageViewContainer)
        imageViewContainer.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
            
            imageViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            imageViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor, constant: 0),
            imageView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor, constant: 200),
            imageView.widthAnchor.constraint(equalTo: imageViewContainer.widthAnchor, multiplier: 1.2),
            imageView.heightAnchor.constraint(equalTo: imageViewContainer.widthAnchor, multiplier: 1.2),
        ])
    }
    
    @objc private func restartTapped() {
        endGamePresenter.onButtonPress()
    }
    
    deinit {
        print("DEALOCATED end-GAME-screen!")
    }
}

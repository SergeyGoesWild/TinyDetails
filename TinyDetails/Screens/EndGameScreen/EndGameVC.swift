//
//  EndGameScreen.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 26/06/2025.
//
import UIKit

final class EndGameVC: UIViewController {
    var dataItem: EndGameData {
        get {
            return endGamePresenter.provideItem()
        }
    }
    
    var endGamePresenter: EndGamePresenterProtocol
    
    private var titleLabel: UILabel!
    private var additionalLabel: UILabel!
    private var backgroundView: UIView!
    private var imageView: UIImageView!
    private var restartButton: UIButton!
    
    init(endGamePresenter: EndGamePresenterProtocol) {
        self.endGamePresenter = endGamePresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        titleLabel.font = .systemFont(ofSize: EndGameConstants.titleLabelFontSize, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.text = dataItem.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        additionalLabel = UILabel()
        additionalLabel.font = .systemFont(ofSize: EndGameConstants.subtitleLabelFontSize, weight: .thin)
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
            spacer.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: EndGameConstants.spacerHeightMult),
            
            titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: spacer.bottomAnchor),
            
            additionalLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            additionalLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: EndGameConstants.textTopMargin),
            
            restartButton.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: EndGameConstants.restartTopMargin),
            restartButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            restartButton.widthAnchor.constraint(equalToConstant: EndGameConstants.restartButtWidth),
            restartButton.heightAnchor.constraint(equalToConstant: EndGameConstants.restartButtHeight),
            
            imageViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            imageViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor, constant: EndGameConstants.imageHorOffset),
            imageView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor, constant: EndGameConstants.imageVerOffset),
            imageView.widthAnchor.constraint(equalTo: imageViewContainer.widthAnchor, multiplier: EndGameConstants.imageWidthMult),
            imageView.heightAnchor.constraint(equalTo: imageViewContainer.widthAnchor, multiplier: EndGameConstants.imageHeightMult),
        ])
    }
    
    @objc private func restartTapped() {
        endGamePresenter.onButtonPress()
    }
    
    deinit {
        print("DEALOCATED: EndGameVC")
    }
}

//
//  EndLevelScreen.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 17/04/2025.
//

import Foundation
import UIKit

final class EndLevelScreen: UIViewController {
    weak var delegate: EndLevelDelegate?
    weak var endGamedelegate: EndGameDelegate?
    
    var isLastLevel: Bool!
    var isFirstLaunch: Bool = true
    var paintingObject: PaintingObject!
    
    var endScrollView: UIScrollView!
    var titleView: UILabel!
    var subtitleView: UILabel!
    var lastLevelLabel: UILabel!
    var descriptionView: UILabel!
    var imageView: UIImageView!
    var nextLevelButton: UIButton!
    
    private let sideMargin: CGFloat = 25
    private var bottomInset: CGFloat!
    
    var bottomConstraint: NSLayoutConstraint!
    var imageWidthConstraint: NSLayoutConstraint!
    var imageHeightConstraint: NSLayoutConstraint!
    
    init(paintingObject: PaintingObject, delegate: EndLevelDelegate, isLastLevel: Bool, endGameDelegate: EndGameDelegate) {
        self.paintingObject = paintingObject
        self.delegate = delegate
        self.isLastLevel = isLastLevel
        self.endGamedelegate = endGameDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        self.isModalInPresentation = true
        
        endScrollView = UIScrollView()
        endScrollView.translatesAutoresizingMaskIntoConstraints = false
        endScrollView.backgroundColor = .clear
        
        titleView = UILabel()
        titleView.text = "Level Complete"
        titleView.textAlignment = .center
        titleView.textColor = .black
        titleView.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.lineBreakMode = .byWordWrapping
        titleView.numberOfLines = 0
        
        subtitleView = UILabel()
        subtitleView.text = paintingObject.endSubtitle
        subtitleView.textAlignment = .center
        subtitleView.textColor = .black
        subtitleView.font = UIFont.italicSystemFont(ofSize: 20)
        subtitleView.translatesAutoresizingMaskIntoConstraints = false
        subtitleView.lineBreakMode = .byWordWrapping
        subtitleView.numberOfLines = 0
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionView = UILabel()
        descriptionView.text = paintingObject.endDescription
        descriptionView.textAlignment = .left
        descriptionView.textColor = .black
        descriptionView.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.lineBreakMode = .byWordWrapping
        descriptionView.numberOfLines = 0
        
        nextLevelButton = UIButton(type: .system)
        nextLevelButton.setTitle(isLastLevel ? "Finish game" : "Next Level", for: .normal)
        nextLevelButton.setTitleColor(.white, for: .normal)
        nextLevelButton.backgroundColor = .systemBlue
        nextLevelButton.layer.cornerRadius = 8
        nextLevelButton.translatesAutoresizingMaskIntoConstraints = false
        nextLevelButton.addTarget(self, action: #selector(nextLevelButtonPushed), for: .touchUpInside)
        
        view.addSubview(endScrollView)
        endScrollView.addSubview(titleView)
        endScrollView.addSubview(subtitleView)
        endScrollView.addSubview(imageView)
        endScrollView.addSubview(descriptionView)
        endScrollView.addSubview(nextLevelButton)

        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 0)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            endScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            endScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            endScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            endScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleView.centerXAnchor.constraint(equalTo: endScrollView.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: endScrollView.topAnchor, constant: 30),
            titleView.widthAnchor.constraint(equalTo: endScrollView.widthAnchor, constant: -sideMargin * 2),
            
            subtitleView.centerXAnchor.constraint(equalTo: endScrollView.centerXAnchor),
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30),
            subtitleView.widthAnchor.constraint(equalTo: endScrollView.widthAnchor, constant: -sideMargin * 2),
            
            imageView.centerXAnchor.constraint(equalTo: endScrollView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: 40),
            imageWidthConstraint,
            imageHeightConstraint,
            
            descriptionView.centerXAnchor.constraint(equalTo: endScrollView.centerXAnchor),
            descriptionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            descriptionView.widthAnchor.constraint(equalTo: endScrollView.widthAnchor, constant: -sideMargin * 2),
            
            nextLevelButton.centerXAnchor.constraint(equalTo: endScrollView.centerXAnchor),
            nextLevelButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 50),
            nextLevelButton.bottomAnchor.constraint(equalTo: endScrollView.bottomAnchor, constant: -20),
            nextLevelButton.widthAnchor.constraint(equalToConstant: 200),
            nextLevelButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         if isFirstLaunch {
             isFirstLaunch = false
             guard let path = Bundle.main.path(forResource: paintingObject.paintingFile, ofType: "jpg") else {
                 print("Item Image not found in EndLevelScreen: ", paintingObject.paintingFile)
                 return
             }
             guard let currentImage = UIImage(contentsOfFile: path) else {
                 print("Image not found in EndLevelScreen (UIImage): ", paintingObject.paintingFile)
                 return
             }
             imageView.image = currentImage
             let imageSize = getImageSize(image: currentImage, view: self.view)
             imageWidthConstraint.constant = imageSize.width
             imageHeightConstraint.constant = imageSize.height
     //        bottomConstraint.constant = -view.safeAreaInsets.bottom
        }
    }
    
    @objc private func nextLevelButtonPushed() {
        if isLastLevel {
            let endGameScreen = EndGameScreen(delegate: endGamedelegate)
            navigationController?.pushViewController(endGameScreen, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
            delegate?.didPassNextLevel()
        }
    }
    
    private func getImageSize(image: UIImage, view: UIView) -> CGSize {
        if image.size.height > image.size.width {
            let wantedHeight = view.frame.height * 0.5
            let multiplier = image.size.height / wantedHeight
            let height = wantedHeight
            let width = image.size.width / multiplier
            return CGSize(width: width, height: height)
        } else {
            let usableWidth = view.frame.width - sideMargin * 2
            let multiplier = image.size.width / usableWidth
            let height = image.size.height / multiplier
            let width = usableWidth
            return CGSize(width: width, height: height)
        }
    }
    
    deinit {
        print("DEALOCATED end-LEVEL-Screen!")
    }
}

//
//  EndLevelScreen.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 17/04/2025.
//

import Foundation
import UIKit

final class EndLevelVC: UIViewController {
    
    var endLevelPresenter: EndLevelPresenterProtocol
    
    var isFirstLaunch: Bool = true
    
    private var paintingObject: PaintingObject {
        get {
            endLevelPresenter.provideItem()
        }
    }
    
    var endScrollView: UIScrollView!
    var titleView: UILabel!
    var subtitleView: UILabel!
    var lastLevelLabel: UILabel!
    var descriptionView: UITextView!
    var imageView: UIImageView!
    var nextLevelButton: UIButton!
    var buttonGradient: CAGradientLayer!
    
    private var bottomInset: CGFloat!
    
    var bottomConstraint: NSLayoutConstraint!
    var imageWidthConstraint: NSLayoutConstraint!
    var imageHeightConstraint: NSLayoutConstraint!
    
    init(endLevelPresenter: EndLevelPresenterProtocol) {
        self.endLevelPresenter = endLevelPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        endLevelPresenter.onAppear()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        self.isModalInPresentation = true
        
        endScrollView = UIScrollView()
        endScrollView.translatesAutoresizingMaskIntoConstraints = false
        endScrollView.showsVerticalScrollIndicator = false
        endScrollView.backgroundColor = .clear
        
        titleView = UILabel()
        titleView.text = "Level Complete"
        titleView.textAlignment = .center
        titleView.textColor = .black
        titleView.font = UIFont.systemFont(ofSize: EndLevelConstants.titleFontSize, weight: .bold)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.lineBreakMode = .byWordWrapping
        titleView.numberOfLines = 0
        
        subtitleView = UILabel()
        subtitleView.text = paintingObject.endSubtitle
        subtitleView.textAlignment = .center
        subtitleView.textColor = .black
        subtitleView.font = UIFont.italicSystemFont(ofSize: EndLevelConstants.subtitleFontSize)
        subtitleView.translatesAutoresizingMaskIntoConstraints = false
        subtitleView.lineBreakMode = .byWordWrapping
        subtitleView.numberOfLines = 0
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionView = UITextView()
        descriptionView.font = UIFont.systemFont(ofSize: EndLevelConstants.descriptionFontSize, weight: .light)
        descriptionView.isEditable = false
        descriptionView.isScrollEnabled = false
        descriptionView.textContainerInset = .zero
        descriptionView.textContainer.lineFragmentPadding = 0
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        let para = NSMutableParagraphStyle()
        para.alignment = .justified
        para.hyphenationFactor = 1.0
        let attr = NSMutableAttributedString(string: paintingObject.endDescription, attributes: [
            .font: UIFont.systemFont(ofSize: EndLevelConstants.descriptionFontSize, weight: .light),
            .paragraphStyle: para,
            NSAttributedString.Key(rawValue: kCTLanguageAttributeName as String): "en"
        ])
        descriptionView.attributedText = attr
        
        nextLevelButton = UIButton(type: .system)
        nextLevelButton.setTitle("Next Level", for: .normal)
        nextLevelButton.setTitleColor(.white, for: .normal)
        nextLevelButton.backgroundColor = .black
        nextLevelButton.layer.cornerRadius = EndLevelConstants.buttonCornerRadius
        nextLevelButton.translatesAutoresizingMaskIntoConstraints = false
        nextLevelButton.addTarget(self, action: #selector(nextLevelButtonPushed), for: .touchUpInside)
        
        nextLevelButton.backgroundColor = .clear
        buttonGradient = CAGradientLayer()
        buttonGradient.colors = [
            UIColor.gray.cgColor,
            UIColor.black.cgColor
        ]
        buttonGradient.locations = [0.0, 1.0]
        buttonGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        buttonGradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        buttonGradient.cornerRadius = nextLevelButton.layer.cornerRadius
        nextLevelButton.layer.insertSublayer(buttonGradient, at: 0)
        
        view.addSubview(endScrollView)
        endScrollView.addSubview(titleView)
        endScrollView.addSubview(subtitleView)
        endScrollView.addSubview(imageView)
        endScrollView.addSubview(descriptionView)
        endScrollView.addSubview(nextLevelButton)

        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 0)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            endScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            endScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            endScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            endScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleView.centerXAnchor.constraint(equalTo: endScrollView.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: endScrollView.topAnchor, constant: EndLevelConstants.titleViewTopMargin),
            titleView.widthAnchor.constraint(equalTo: endScrollView.widthAnchor, constant: -EndLevelConstants.endLevelSideMargin * 2),
            
            subtitleView.centerXAnchor.constraint(equalTo: endScrollView.centerXAnchor),
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: EndLevelConstants.subtitleViewTopMargin),
            subtitleView.widthAnchor.constraint(equalTo: endScrollView.widthAnchor, constant: -EndLevelConstants.endLevelSideMargin * 2),
            
            descriptionView.centerXAnchor.constraint(equalTo: endScrollView.centerXAnchor),
            descriptionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: EndLevelConstants.descriptionTopMargin),
            descriptionView.widthAnchor.constraint(equalTo: endScrollView.widthAnchor, constant: -EndLevelConstants.endLevelSideMargin * 2),
            
            nextLevelButton.centerXAnchor.constraint(equalTo: endScrollView.centerXAnchor),
            nextLevelButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: EndLevelConstants.buttonTopMargin),
            nextLevelButton.bottomAnchor.constraint(equalTo: endScrollView.bottomAnchor, constant: -EndLevelConstants.buttonBotMargin),
            nextLevelButton.widthAnchor.constraint(equalToConstant: EndLevelConstants.buttonWidth),
            nextLevelButton.heightAnchor.constraint(equalToConstant: EndLevelConstants.buttonHeight),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if buttonGradient.frame != nextLevelButton.bounds {
                buttonGradient.frame = nextLevelButton.bounds
            }
    }
    
    @objc private func nextLevelButtonPushed() {
        endLevelPresenter.onButtonPress()
    }
    
    private func setupImageView() {
        guard let path = Bundle.main.path(forResource: paintingObject.paintingFile, ofType: "jpg") else {
            print("Item Image not found in EndLevelScreen: ", paintingObject.paintingFile)
            return
        }
        guard let currentImage = UIImage(contentsOfFile: path) else {
            print("Image not found in EndLevelScreen (UIImage): ", paintingObject.paintingFile)
            return
        }
        imageView.image = currentImage
        setupImageConstraints(image: currentImage)
    }
    
    private func setupImageConstraints(image: UIImage) {
        if image.size.width > image.size.height {
            let ratio = image.size.height / image.size.width
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: endScrollView.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: EndLevelConstants.imageViewTopMargin),
                imageView.leadingAnchor.constraint(equalTo: endScrollView.leadingAnchor, constant: EndLevelConstants.endLevelSideMargin),
                imageView.trailingAnchor.constraint(equalTo: endScrollView.trailingAnchor, constant: -EndLevelConstants.endLevelSideMargin),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: ratio),
            ])
        } else {
            let ratio = image.size.width / image.size.height
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: endScrollView.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: EndLevelConstants.imageViewTopMargin),
                imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 400),
                imageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -(EndLevelConstants.endLevelSideMargin * 2)),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: ratio),
            ])
        }
    }
    
    deinit {
        print("DEALOCATED: EndLevelVC")
    }
}

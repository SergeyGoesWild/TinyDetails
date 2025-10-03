//
//  ViewController.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 16/03/2025.
//

import UIKit

protocol LevelViewProtocol: AnyObject {
    func launchNextArea(clickableAreaData: ClickableArea)
    func launchNewLevel()
    func showQuestion(withAnimation: Bool)
}

protocol ClickableAreaDelegate: AnyObject {
    func didReceiveClick(area: ClickableAreaView)
}

protocol TutorialDelegate: AnyObject {
    func leavingTutorial()
}

class LevelVC: UIViewController, LevelViewProtocol {
    
    var levelPresenter: LevelPresenterProtocol
    
    var isFirstLaunch: Bool = true
    
    var currentLevel: PaintingObject {
        return levelPresenter.provideLevel()
    }
    
    var currentArea: ClickableArea {
        return levelPresenter.provideArea()
    }
    
    var imageViewSize: CGSize!
    var smallScreen: Bool = false
    
    var widthConstraintImagePH: NSLayoutConstraint!
    var heightConstraintImagePH: NSLayoutConstraint!
    var questionLabelViewBottomConstraint: NSLayoutConstraint!
    var questionPaddingConstraintBottom: NSLayoutConstraint!
    
    var bgSolid: UIView!
    var imagePH: UIImageView!
    var centerCommon: UIView!
    var centerScroll: UIView!
    var scrollView: UIScrollView!
    var questionLabelContainer: UIView!
    var questionLabelView: QuestionLabelView!
    var image: UIImage!
    var clickableArea: ClickableAreaView!
    var confirmationOverlayView: ConfirmationOverlay!
    private var tutorialOverlay: TutorialOverlay?
    
    init(levelPresenter: LevelPresenterProtocol) {
        self.levelPresenter = levelPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNormalLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLaunch {
            isFirstLaunch = false
            levelPresenter.launchGame()
            setupResponsive()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        levelPresenter.onAppear()
        tutorialOverlay?.startTutorialCountdown()
    }
    
    private func setupResponsive() {
        questionPaddingConstraintBottom.constant = view.safeAreaInsets.bottom < AppThreshold.safeAreaInset ? -LevelConstants.additionalVertPadding : 0
        view.layoutIfNeeded()
    }
    
    // MARK: - Flow
    
    func launchNewLevel() {
        setupBgPicture(currentLevel: currentLevel)
        if let tutorialData = currentLevel.tutorialData {
            setupTutorial(data: tutorialData)
        }
        launchNextArea(clickableAreaData: currentArea)
        scrollView.zoomScale = 1
    }
    
    func launchNextArea(clickableAreaData: ClickableArea) {
        setupClickableArea()
        clickableArea.updateClickableArea(with: clickableAreaData)
        levelPresenter.pickRightAnimation()
    }
    
    private func setupTutorial(data: TutorialData) {
        tutorialOverlay = TutorialOverlay(delegate: self, title: data.title, hintText: data.explainerText, iconName: data.iconName)
        guard let tutorialOverlay else { return }
        tutorialOverlay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tutorialOverlay)
        
        NSLayoutConstraint.activate([
            tutorialOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tutorialOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tutorialOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            tutorialOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    func showQuestion(withAnimation animated: Bool) {
        if animated {
            questionLabelView.alpha = 0.0
            questionLabelView.updateItemText(itemText: currentArea.hintText)
            questionLabelViewBottomConstraint.constant = -LevelConstants.questionGoAwayDist
            view.layoutIfNeeded()
            
            UIView.animate(withDuration: LevelConstants.questionGoAwayLen, delay: 0, options: [.curveEaseOut], animations: {
                self.questionLabelView.alpha = 1.0
                self.questionLabelViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            questionLabelView.alpha = 1.0
            questionLabelViewBottomConstraint.constant = 0
            questionLabelView.updateItemText(itemText: currentArea.hintText)
        }
    }
    
    // MARK: - Layout
    
    private func setupNormalLayout() {
        let screenSize = UIScreen.main.bounds
        smallScreen = screenSize.width <= AppThreshold.smallScreenWidthMarg && screenSize.height < AppThreshold.smallScreenHeightMarg
        
        bgSolid = UIView()
        bgSolid.backgroundColor = .black
        bgSolid.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = LevelConstants.scrollViewMin
        scrollView.maximumZoomScale = LevelConstants.scrollViewMax
        scrollView.bouncesZoom = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        questionLabelContainer = UIView()
        questionLabelContainer.backgroundColor = .clear
        questionLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        questionLabelContainer.isUserInteractionEnabled = false
        questionPaddingConstraintBottom = questionLabelContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        
        questionLabelView = QuestionLabelView(questionText: "Can you find:", itemText: currentArea.hintText, smallScreen: smallScreen)
        questionLabelView.translatesAutoresizingMaskIntoConstraints = false
        questionLabelView.isUserInteractionEnabled = false
        questionLabelView.isHidden = false
        questionLabelView.alpha = 0.0
        questionLabelViewBottomConstraint = questionLabelView.bottomAnchor.constraint(equalTo: questionLabelContainer.bottomAnchor, constant: -LevelConstants.questionGoAwayDist)
        
        centerCommon = UIView()
        centerCommon.backgroundColor = .black
        centerCommon.translatesAutoresizingMaskIntoConstraints = false
        
        centerScroll = UIView()
        centerScroll.backgroundColor = .white
        centerScroll.translatesAutoresizingMaskIntoConstraints = false
        
        imagePH = UIImageView()
        imagePH.translatesAutoresizingMaskIntoConstraints = false
        imagePH.isUserInteractionEnabled = true
        widthConstraintImagePH = imagePH.widthAnchor.constraint(equalToConstant: 0)
        heightConstraintImagePH = imagePH.heightAnchor.constraint(equalToConstant: 0)
        
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.isUserInteractionEnabled = false
        
        confirmationOverlayView = ConfirmationOverlay()
        confirmationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        confirmationOverlayView.isUserInteractionEnabled = true
        confirmationOverlayView.isHidden = true
        confirmationOverlayView.alpha = 1.0
        
        view.addSubview(bgSolid)
        view.addSubview(scrollView)
        scrollView.addSubview(imagePH)
        view.addSubview(gradientView)
        view.addSubview(questionLabelContainer)
        questionLabelContainer.addSubview(questionLabelView)
        view.addSubview(confirmationOverlayView)
        
        NSLayoutConstraint.activate([
            bgSolid.widthAnchor.constraint(equalTo: view.widthAnchor),
            bgSolid.heightAnchor.constraint(equalTo: view.heightAnchor),
            bgSolid.topAnchor.constraint(equalTo: view.topAnchor),
            bgSolid.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: LevelConstants.scrollViewHeightMult),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            questionLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            questionPaddingConstraintBottom,
            
            questionLabelViewBottomConstraint,
            questionLabelView.leadingAnchor.constraint(equalTo: questionLabelContainer.leadingAnchor, constant: LevelConstants.questionViewSidePadding),
            questionLabelView.trailingAnchor.constraint(equalTo: questionLabelContainer.trailingAnchor, constant: -LevelConstants.questionViewSidePadding),
            
            confirmationOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmationOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            confirmationOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            confirmationOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.heightAnchor.constraint(equalTo: questionLabelContainer.heightAnchor, multiplier: LevelConstants.gradientViewHeightMult),
            gradientView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            widthConstraintImagePH,
            heightConstraintImagePH,
            imagePH.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imagePH.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            
        ])
    }
    
    private func setupBgPicture(currentLevel: PaintingObject) {
        guard let path = Bundle.main.path(forResource: currentLevel.paintingFile, ofType: "jpg") else {
            print("Level Image path not found: ", currentLevel.paintingTitle)
            return
        }
        
        guard let currentLevelImage = UIImage(contentsOfFile: path) else {
            print("Level Image file not found in ViewController (UIImage): ", currentLevel.paintingTitle)
            return
        }
        imagePH.image = currentLevelImage
        
        imageViewSize = getImageSize(image: currentLevelImage, scrollView: scrollView)
        
        widthConstraintImagePH.constant = imageViewSize.width
        heightConstraintImagePH.constant = imageViewSize.height
        
        scrollView.layoutIfNeeded()
        
        if scrollView.contentSize != CGSize(width: imageViewSize.width, height: imageViewSize.height) {
            scrollView.contentSize = CGSize(width: imageViewSize.width, height: imageViewSize.height)
        }
        
        let centerX = (scrollView.contentSize.width - scrollView.bounds.width) / 2
        let centerY = (scrollView.contentSize.height - scrollView.bounds.height) / 2
        scrollView.setContentOffset(CGPoint(x: centerX + scrollView.contentSize.width * currentLevel.paintingOffset, y: centerY), animated: false)
    }
    
    // MARK: - Service
    
    private func getImageSize(image: UIImage, scrollView: UIScrollView) -> CGSize {
        guard scrollView.frame.height > 0 else { return image.size }
        
        let multiplier = image.size.height / scrollView.frame.height
        let height = scrollView.frame.height
        let width = image.size.width / multiplier
        return CGSize(width: width, height: height)
    }
    
    private func setupClickableArea() {
        clickableArea?.removeFromSuperview()
        clickableArea = nil
        
        clickableArea = ClickableAreaView()
        clickableArea.delegate = self
        clickableArea.translatesAutoresizingMaskIntoConstraints = false
        imagePH.addSubview(clickableArea)
        NSLayoutConstraint.activate([
            clickableArea.widthAnchor.constraint(equalTo: imagePH.widthAnchor),
            clickableArea.heightAnchor.constraint(equalTo: imagePH.heightAnchor),
            clickableArea.leadingAnchor.constraint(equalTo: imagePH.leadingAnchor),
            clickableArea.topAnchor.constraint(equalTo: imagePH.topAnchor),
        ])
        imagePH.bringSubviewToFront(clickableArea)
    }
    
    deinit {
        print("DEALOCATED: LevelVC")
    }
}

// MARK: - Extensions

extension LevelVC: ClickableAreaDelegate {
    func didReceiveClick(area: ClickableAreaView) {
        confirmationOverlayView.updateConfirmationOverlay(areaData: currentArea)
        confirmationOverlayView.isHidden = false
        UIView.animate(withDuration: LevelConstants.questionGoAwayLen, animations: {
            self.questionLabelView.alpha = 0
            self.questionLabelViewBottomConstraint.constant = LevelConstants.questionGoAwayDist
            self.questionLabelContainer.layoutIfNeeded()
        })
        confirmationOverlayView.revealOverlay(completion: {
            self.confirmationOverlayView.isHidden = true
            self.levelPresenter.onAreaPress()
        })
    }
}

extension LevelVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePH
    }
}

extension LevelVC: TutorialDelegate {
    func leavingTutorial() {
        showQuestion(withAnimation: true)
        tutorialOverlay?.removeFromSuperview()
        tutorialOverlay = nil
    }
}

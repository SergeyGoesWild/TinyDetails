//
//  ViewController.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 16/03/2025.
//

import UIKit

protocol ClickableAreaDelegate: AnyObject {
    func didReceiveClick(area: ClickableAreaView)
}

protocol EndLevelDelegate: AnyObject {
    func enteredEndLevel()
    func didPassNextLevel()
}

protocol EndGameDelegate: AnyObject {
    func enteredEndGame()
    func restartGame()
}

protocol TutorialDelegate: AnyObject {
    func leavingTutorial()
}

class GameVC: UIViewController {
    static let paintingList = DataProvider.shared.paintingList
    static let saveProvider = SaveProvider.shared
    
    var currentLevelIndex: Int = 0
    var currentItemIndex: Int = 0
    
    var isFirstLaunch: Bool = true
    
    var currentLevel: PaintingObject {
        return GameVC.paintingList[currentLevelIndex]
    }
    
    var currentItem: ClickableArea {
        return GameVC.paintingList[currentLevelIndex].areas[currentItemIndex]
    }
    
    var levelIsOver: Bool {
        return currentItemIndex >= currentLevel.areas.count - 1
    }
    
    var gameIsOver: Bool {
        return currentLevelIndex >= GameVC.paintingList.count - 1
    }
    
    var imageViewSize: CGSize!
    var skipStartAnimation: Bool = true
    var smallScreen: Bool = false
    
    let sideMargin: CGFloat = 16
    
    var widthConstraintImagePH: NSLayoutConstraint!
    var heightConstraintImagePH: NSLayoutConstraint!
    var questionLabelViewbottomConstraint: NSLayoutConstraint!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadSaveData()
        setupNormalLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLaunch {
            setupPictureLayout(currentLevel: currentLevel)
            launchNextItem(clickableAreaData: currentItem)
            isFirstLaunch = false
        }
    }
    
    // MARK: - Flow
    
    private func launchNextItem(clickableAreaData: ClickableArea) {
        clickableArea.updateClickableArea(with: clickableAreaData)
        
        if currentItemIndex == 0 || skipStartAnimation {
            questionLabelView.alpha = 1.0
            questionLabelViewbottomConstraint.constant = 0
            questionLabelView.updateItemText(itemText: currentItem.hintText)
        } else {
            questionLabelView.alpha = 0.0
            questionLabelView.updateItemText(itemText: currentItem.hintText)
            questionLabelViewbottomConstraint.constant = -50
            view.layoutIfNeeded()

            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                self.questionLabelView.alpha = 1.0
                self.questionLabelViewbottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func launchNextLevel() {
        removeClickableAreas()
        currentLevelIndex += 1
        currentItemIndex = 0
        savingData(onModal: false, onEnd: false)
        setupPictureLayout(currentLevel: self.currentLevel)
        if let tutorialData = self.currentLevel.tutorialData {
            setupTutorial(data: tutorialData)
        }
        launchNextItem(clickableAreaData: self.currentItem)
        scrollView.zoomScale = 1
    }
    
    private func checkLevelComplete() {
        if levelIsOver {
            showEndLevelModal()
            if !gameIsOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.scrollView.zoomScale = 1
                    self.launchNextLevel()
                }
            }
        } else {
            currentItemIndex += 1
            savingData(onModal: false, onEnd: false)
            launchNextItem(clickableAreaData: currentItem)
        }
    }
    
    private func showEndLevelModal() {
        let endLevelScreen = EndLevelScreen(paintingObject: currentLevel, delegate: self, isLastLevel: gameIsOver, endGameDelegate: self)
        navigationController?.pushViewController(endLevelScreen, animated: true)
    }
    
    // MARK: - Layout
    
    private func setupNormalLayout() {
        let screenSize = UIScreen.main.bounds
        smallScreen = screenSize.width <= 375 && screenSize.height < 812
        
        bgSolid = UIView()
        bgSolid.backgroundColor = .black
        bgSolid.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.bouncesZoom = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        questionLabelContainer = UIView()
        questionLabelContainer.backgroundColor = .clear
        questionLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        questionLabelContainer.isUserInteractionEnabled = false
        
        questionLabelView = QuestionLabelView(questionText: "Can you find", itemText: currentItem.hintText, smallScreen: smallScreen)
        questionLabelView.translatesAutoresizingMaskIntoConstraints = false
        questionLabelView.isUserInteractionEnabled = false
        questionLabelViewbottomConstraint = questionLabelView.bottomAnchor.constraint(equalTo: questionLabelContainer.bottomAnchor, constant: 0)
        questionLabelView.isHidden = false
        
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
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 8/9),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            questionLabelContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionLabelContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            questionLabelContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            questionLabelViewbottomConstraint,
            questionLabelView.leadingAnchor.constraint(equalTo: questionLabelContainer.leadingAnchor, constant: 16),
            questionLabelView.trailingAnchor.constraint(equalTo: questionLabelContainer.trailingAnchor, constant: -16),
            
            confirmationOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmationOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            confirmationOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            confirmationOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.heightAnchor.constraint(equalTo: questionLabelContainer.heightAnchor, multiplier: 0.15),
            gradientView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            widthConstraintImagePH,
            heightConstraintImagePH,
            imagePH.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imagePH.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            
        ])
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
    
    private func setupPictureLayout(currentLevel: PaintingObject) {
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
        
        setupClickableArea()
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
    
    private func removeClickableAreas() {
        for area in imagePH.subviews.compactMap({ $0 as? ClickableAreaView }) {
            area.removeFromSuperview()
        }
    }
    
    private func loadSaveData() {
        currentLevelIndex = SaveProvider.shared.latestLevelIndex
//        currentItemIndex = SaveProvider.shared.latestItemIndex
    }
    
    private func savingData(onModal: Bool, onEnd: Bool) {
        SaveProvider.shared.latestLevelIndex = currentLevelIndex
        SaveProvider.shared.latestItemIndex = currentItemIndex
        SaveProvider.shared.onModal = onModal
        SaveProvider.shared.onEndScreen = onEnd
    }
}

extension GameVC: ClickableAreaDelegate {
    func didReceiveClick(area: ClickableAreaView) {
        skipStartAnimation = false
        confirmationOverlayView.updateConfirmationOverlay(areaData: currentItem)
        confirmationOverlayView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.questionLabelView.alpha = 0
            self.questionLabelViewbottomConstraint.constant = 50
            self.questionLabelContainer.layoutIfNeeded()
        })
        confirmationOverlayView.revealOverlay(completion: {
            self.confirmationOverlayView.isHidden = true
            self.checkLevelComplete()
        })
    }
}

extension GameVC: EndLevelDelegate {
    func enteredEndLevel() {

    }
    
    func didPassNextLevel() {
        
    }
}

extension GameVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePH
    }
}

extension GameVC: EndGameDelegate {
    func enteredEndGame() {

    }
    
    func restartGame() {
        removeClickableAreas()
        currentItemIndex = 0
        currentLevelIndex = 0
        savingData(onModal: false, onEnd: false)
        skipStartAnimation = true
        scrollView.zoomScale = 1
        setupPictureLayout(currentLevel: currentLevel)
        launchNextItem(clickableAreaData: currentItem)
    }
}

extension GameVC: TutorialDelegate {
    func leavingTutorial() {
        print("about to leave tutorial")
        tutorialOverlay?.removeFromSuperview()
        tutorialOverlay = nil
    }
}

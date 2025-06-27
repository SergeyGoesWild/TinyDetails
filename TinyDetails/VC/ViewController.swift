//
//  ViewController.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 16/03/2025.
//

import UIKit

protocol ClickableAreaDelegate: AnyObject {
    func didReceiveClick(area: ClickableAreaView)
    func showOverlay()
}

protocol EndLevelDelegate: AnyObject {
    func didPassNextLevel()
}

class ViewController: UIViewController {
    static let paintingList = DataProvider.shared.paintingList

    var currentLevelIndex: Int = 0
    var currentItemIndex: Int = 0
    
    var currentLevel: PaintingObject {
        return ViewController.paintingList[currentLevelIndex]
    }
    
    var currentItem: ClickableArea {
        return ViewController.paintingList[currentLevelIndex].areas[currentItemIndex]
    }
    
    var levelIsOver: Bool {
        return currentItemIndex >= currentLevel.areas.count - 1
    }
    
    var gameIsOver: Bool {
        return currentLevelIndex >= ViewController.paintingList.count - 1
    }
    
    var imageViewSize: CGSize!
    var isFirstLaunch: Bool = true
    var inTransition: Bool = false
    
    let sideMargin: CGFloat = 16
    let collectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    var widthConstraintImagePH: NSLayoutConstraint!
    var heightConstraintImagePH: NSLayoutConstraint!
    var questionLabelViewbottomConstraint: NSLayoutConstraint!
    
    var bgSolid: UIView!
    var imagePH: UIImageView!
    var centerCommon: UIView!
    var centerScroll: UIView!
    var scrollView: UIScrollView!
    var questionLabelView: QuestionLabelView!
    var image: UIImage!
    var clickableArea: ClickableAreaView!
    var confirmationOverlayView: ConfirmationOverlay!
    var endGameView: EndGameScreen!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNormalLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLaunch {
            isFirstLaunch = false
            print("in FIRST LAUNCH")
            print("1: ", isFirstLaunch)
            setupPictureLayout(currentLevel: currentLevel)
            setNextItem(clickableAreaData: currentItem)
            print("2: ", isFirstLaunch)
        }
    }
    
    // MARK: - Flow
    
    private func setNextItem(clickableAreaData: ClickableArea) {
        clickableArea.updateClickableArea(with: clickableAreaData)
        
        if currentItemIndex == 0 {
            questionLabelView.alpha = 1.0
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
    
    private func checkLevelComplete() {
        print("level is over??? ", levelIsOver)
        if levelIsOver {
            print("about CHANGE LEVEL")
            changeLevel()
        } else {
            print("about SET ITEM")
            currentItemIndex += 1
            setNextItem(clickableAreaData: currentItem)
        }
    }
    
    @objc private func changeLevel() {
        
        let endLevelScreen = EndLevelScreen(paintingObject: currentLevel, delegate: self, isLastLevel: gameIsOver)
        endLevelScreen.modalPresentationStyle = .automatic
        present(endLevelScreen, animated: true, completion: nil)
        
        if !gameIsOver {
            removeClickableAreas()
            currentLevelIndex += 1
            currentItemIndex = 0
            
            // TODO: TRASH, CHANGE THAT, THE ANIMATION PREVENTS CONTROL
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.setupPictureLayout(currentLevel: self.currentLevel)
                self.setNextItem(clickableAreaData: self.currentItem)
                self.scrollView.zoomScale = 1
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.endGameView.isHidden = false
            }
        }
    }
    
    // MARK: - Layout
    
    private func setupNormalLayout() {
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
        
        questionLabelView = QuestionLabelView(questionText: "Can you find", itemText: currentItem.hintText)
        questionLabelView.translatesAutoresizingMaskIntoConstraints = false
        questionLabelViewbottomConstraint = questionLabelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
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
        confirmationOverlayView.isUserInteractionEnabled = false
        confirmationOverlayView.isHidden = false
        confirmationOverlayView.alpha = 1.0
        
        endGameView = EndGameScreen()
        endGameView.translatesAutoresizingMaskIntoConstraints = false
        endGameView.isUserInteractionEnabled = false
        endGameView.isHidden = true
        
        view.addSubview(bgSolid)
        view.addSubview(scrollView)
        scrollView.addSubview(imagePH)
        view.addSubview(gradientView)
        view.addSubview(questionLabelView)
        view.addSubview(confirmationOverlayView)
        view.addSubview(endGameView)
        
        NSLayoutConstraint.activate([
            bgSolid.widthAnchor.constraint(equalTo: view.widthAnchor),
            bgSolid.heightAnchor.constraint(equalTo: view.heightAnchor),
            bgSolid.topAnchor.constraint(equalTo: view.topAnchor),
            bgSolid.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            questionLabelViewbottomConstraint,
            questionLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            confirmationOverlayView.widthAnchor.constraint(equalTo: view.widthAnchor),
            confirmationOverlayView.heightAnchor.constraint(equalTo: view.heightAnchor),
            confirmationOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            confirmationOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.heightAnchor.constraint(equalTo: questionLabelView.heightAnchor, constant: 30),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            endGameView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            endGameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            endGameView.topAnchor.constraint(equalTo: view.topAnchor),
            endGameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            widthConstraintImagePH,
            heightConstraintImagePH,
            imagePH.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imagePH.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            
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
        scrollView.setContentOffset(CGPoint(x: centerX+currentLevel.paintingOffset, y: centerY), animated: false)
        
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
    
//    private func fillClickableArea(clickableAreaData: ClickableArea) {
//        clickableArea.updateClickableArea(with: clickableAreaData)
//    }
    
    private func removeClickableAreas() {
        for area in imagePH.subviews.compactMap({ $0 as? ClickableAreaView }) {
            area.removeFromSuperview()
        }
    }
}

extension ViewController: ClickableAreaDelegate {
    func showOverlay() {
        confirmationOverlayView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmationOverlayView.alpha = 1
            self.questionLabelView.alpha = 0
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.confirmationOverlayView.alpha = 0
                }, completion: { _ in
                    self.confirmationOverlayView.isHidden = true
                })
            }
        })
    }
    
    func didReceiveClick(area: ClickableAreaView) {
        clickableArea.launchRightGuessAnimation {
            self.checkLevelComplete()
        }
    }
}

extension ViewController: EndLevelDelegate {
    func didPassNextLevel() {
//        changeLevel()
//        completion()
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePH
    }
    
    //    func scrollViewDidZoom(_ scrollView: UIScrollView) {
    //        if scrollView.zoomScale < 1.0 {
    //            scrollView.setZoomScale(1.0, animated: false)
    //        }
    //    }
}


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
    func didPassNextLevel(completion: @escaping () -> Void)
}

class ViewController: UIViewController {
    static let paintingList = DataProvider.shared.paintingList
    var resultModel: [ResultObject] = []
    
    var hintTimer: Timer?
    
    var imageViewSize: CGSize!
    var redrawing: Bool = true
    var inTransition: Bool = false
    
    let sideMargin: CGFloat = 16
    let collectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    var currentLevel: Int = 0
    var widthConstraintImagePH: NSLayoutConstraint!
    var heightConstraintImagePH: NSLayoutConstraint!
    
    var bgSolid: UIView!
    var imagePH: UIImageView!
    var centerCommon: UIView!
    var centerScroll: UIView!
    var scrollView: UIScrollView!
    var questionTextLabel: UILabel!
    var itemTextLabel: UILabel!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("eeeeeeee")
        setupResultModel()
        setupNormalLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("REDRAWING")
        if redrawing {
            setupPictureLayout(currentLevel: currentLevel)
            setupClickableAreas()
        }
        redrawing = false
    }
    
    private func getImageSize(image: UIImage, scrollView: UIScrollView) -> CGSize {
        guard scrollView.frame.height > 0 else { return image.size }
        
        let multiplier = image.size.height / scrollView.frame.height
        let height = scrollView.frame.height
        let width = image.size.width / multiplier
        return CGSize(width: width, height: height)
    }
    
    private func checkLevelComplete() {
        for item in resultModel {
            if !item.wasClicked {
                return
            }
        }
        let endLevelScreen = EndLevelScreen(paintingObject: ViewController.paintingList[currentLevel], delegate: self)
        endLevelScreen.modalPresentationStyle = .automatic
        // TODO: Find a more elegant solution
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.present(endLevelScreen, animated: true, completion: nil)
        }
    }
    
    @objc private func changeLevel() {
        currentLevel += 1
        resultModel = []
        setupResultModel()
        // TODO: TRASH, CHANGE THAT, THE ANIMATION PREVENTS CONTROL
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setupPictureLayout(currentLevel: self.currentLevel)
            self.setupClickableAreas()
            self.scrollView.zoomScale = 1
        }
    }
    
    private func setupResultModel() {
        for area in ViewController.paintingList[currentLevel].areas {
            let newObject = ResultObject(id: area.idArea, title: area.hintText, wasClicked: false)
            resultModel.append(newObject)
        }
    }
    
    private func setupNormalLayout() {
        
        bgSolid = UIView()
        bgSolid.backgroundColor = UIColor(red: 0.18, green: 0.53, blue: 0.87, alpha: 1.00)
        bgSolid.translatesAutoresizingMaskIntoConstraints = false
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnHint))
//        hintTouchField.addGestureRecognizer(tapGesture)
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.bouncesZoom = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        itemTextLabel = UILabel()
        itemTextLabel.text = "Adam?"
        itemTextLabel.textColor = .white
        itemTextLabel.font = UIFont.systemFont(ofSize: 55, weight: .bold)
        itemTextLabel.textAlignment = .left
        itemTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        questionTextLabel = UILabel()
        questionTextLabel.text = "Can you find"
        questionTextLabel.textColor = .white
        questionTextLabel.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        questionTextLabel.textAlignment = .left
        questionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bgSolid)
        view.addSubview(scrollView)
        //        view.addSubview(centerCommon)
        scrollView.addSubview(imagePH)
        view.addSubview(questionTextLabel)
        view.addSubview(itemTextLabel)
        //        imagePH.addSubview(centerScroll)
        
        NSLayoutConstraint.activate([
            bgSolid.widthAnchor.constraint(equalTo: view.widthAnchor),
            bgSolid.heightAnchor.constraint(equalTo: view.heightAnchor),
            bgSolid.topAnchor.constraint(equalTo: view.topAnchor),
            bgSolid.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            itemTextLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            itemTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            questionTextLabel.bottomAnchor.constraint(equalTo: itemTextLabel.topAnchor, constant: 5),
            questionTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            widthConstraintImagePH,
            heightConstraintImagePH,
            imagePH.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imagePH.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            
        ])
    }
    
    private func setupClickableArea(areaData: ClickableArea) {
        let area = ClickableAreaView(id: areaData.idArea)
        area.delegate = self
        area.translatesAutoresizingMaskIntoConstraints = false
        imagePH.addSubview(area)
        NSLayoutConstraint.activate([
            area.widthAnchor.constraint(equalToConstant: areaData.size),
            area.heightAnchor.constraint(equalToConstant: areaData.size),
            area.leadingAnchor.constraint(equalTo: imagePH.leadingAnchor, constant: imageViewSize.width * (areaData.xPercent / 100) - CGFloat(areaData.size / 2)),
            area.topAnchor.constraint(equalTo: imagePH.topAnchor, constant: imageViewSize.height * (areaData.yPercent / 100) - CGFloat(areaData.size / 2)),
        ])
        imagePH.bringSubviewToFront(area)
    }
    
    private func setupPictureLayout(currentLevel: Int) {
        for area in imagePH.subviews.compactMap({ $0 as? ClickableAreaView }) {
            area.removeFromSuperview()
        }
        
        image = UIImage(named: ViewController.paintingList[currentLevel].paintingFile)
        imagePH.image = image
        
        imageViewSize = getImageSize(image: image, scrollView: scrollView)
        
        widthConstraintImagePH.constant = imageViewSize.width
        heightConstraintImagePH.constant = imageViewSize.height
        
        scrollView.layoutIfNeeded()
        
        if scrollView.contentSize != CGSize(width: imageViewSize.width, height: imageViewSize.height) {
            scrollView.contentSize = CGSize(width: imageViewSize.width, height: imageViewSize.height)
        }
        
        let centerX = (scrollView.contentSize.width - scrollView.bounds.width) / 2
        let centerY = (scrollView.contentSize.height - scrollView.bounds.height) / 2
        scrollView.setContentOffset(CGPoint(x: centerX, y: centerY), animated: false)
    }
    
    func findCellWithID(_ id: UUID) {
        guard let index = ViewController.paintingList[currentLevel].areas.firstIndex(where: { $0.idArea == id }) else {
            return
        }
        let indexPath = IndexPath(item: index, section: 0)
        if let resultIndex = resultModel.firstIndex(where: {$0.id == id}) {
            resultModel[resultIndex].wasClicked = true
//            collectionView.reloadItems(at: [indexPath])
            checkLevelComplete()
        }
    }
    
    func setupClickableAreas() {
        for areaItem in ViewController.paintingList[currentLevel].areas {
            setupClickableArea(areaData: areaItem)
        }
    }
}

extension ViewController: ClickableAreaDelegate {
    func didReceiveClick(area: ClickableAreaView) {
        findCellWithID(area.areaID)
    }
}

extension ViewController: EndLevelDelegate {
    func didPassNextLevel(completion: @escaping () -> Void) {
        changeLevel()
        completion()
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


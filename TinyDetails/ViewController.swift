//
//  ViewController.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 16/03/2025.
//

import UIKit

protocol ClickableAreaDelegate {
    func didReceiveClick(area: ClickableAreaView)
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
    
    var currentLevel: Int = 2
    var widthConstraintImagePH: NSLayoutConstraint!
    var heightConstraintImagePH: NSLayoutConstraint!
    
    var bgSolid: UIView!
    var imagePH: UIImageView!
    var centerCommon: UIView!
    var centerScroll: UIView!
    var scrollView: UIScrollView!
    var image: UIImage!
    var bottomView: UIView!
    var collectionView: UICollectionView!
    var hintView: UIView!
    var hintLabel: UILabel!
    var closeImage: UIImageView!
    var hintTouchField: UIView!
    
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
        changeLevel()
    }
    
    @objc private func changeLevel() {
        currentLevel += 1
        resultModel = []
        setupResultModel()
        // NOTE: TRASH, CHANGE THAT, THE ANIMATION PREVENTS CONTROL
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setupPictureLayout(currentLevel: self.currentLevel)
            self.setupClickableAreas()
            self.collectionView.reloadData()
        }
    }
    
    private func setupResultModel() {
        for area in ViewController.paintingList[currentLevel].areas {
            let newObject = ResultObject(id: area.idArea, title: area.hintText, wasClicked: false)
            resultModel.append(newObject)
        }
    }
    
    private func setupNormalLayout() {
        bottomView = UIView()
        bottomView.backgroundColor = UIColor(red: 0.18, green: 0.53, blue: 0.87, alpha: 1.00)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        bgSolid = UIView()
        bgSolid.backgroundColor = UIColor(red: 0.18, green: 0.53, blue: 0.87, alpha: 1.00)
        bgSolid.translatesAutoresizingMaskIntoConstraints = false
        
        hintView = UIView()
        hintView.translatesAutoresizingMaskIntoConstraints = false
        hintView.isHidden = true
        hintView.alpha = 0
        hintView.backgroundColor = .black
        
        hintLabel = UILabel()
        hintLabel.text = ""
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.textAlignment = .center
        hintLabel.textColor = .white
        hintLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        hintLabel.numberOfLines = 0
        hintLabel.lineBreakMode = .byWordWrapping
        hintLabel.isHidden = true
        hintLabel.alpha = 0
        
        hintTouchField = UIView()
        hintTouchField.isUserInteractionEnabled = false
        hintTouchField.backgroundColor = .clear
        hintTouchField.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnHint))
        hintTouchField.addGestureRecognizer(tapGesture)
        
        let closeIcon = UIImage(systemName: "multiply.circle")
        closeImage = UIImageView(image: closeIcon)
        closeImage.translatesAutoresizingMaskIntoConstraints = false
        closeImage.tintColor = .white
        closeImage.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 72, weight: .thin)
        closeImage.isHidden = true
        closeImage.alpha = 0
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
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
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 0.18, green: 0.53, blue: 0.87, alpha: 1.00)
        collectionView.register(ClickableAreaCell.self, forCellWithReuseIdentifier: "ClickableAreaCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(bgSolid)
        view.addSubview(scrollView)
//        view.addSubview(centerCommon)
        view.addSubview(bottomView)
        view.addSubview(hintView)
        view.addSubview(hintLabel)
        view.addSubview(closeImage)
        view.addSubview(hintTouchField)
        bottomView.addSubview(collectionView)
        scrollView.addSubview(imagePH)
//        imagePH.addSubview(centerScroll)
        
        NSLayoutConstraint.activate([
            bgSolid.widthAnchor.constraint(equalTo: view.widthAnchor),
            bgSolid.heightAnchor.constraint(equalTo: view.heightAnchor),
            bgSolid.topAnchor.constraint(equalTo: view.topAnchor),
            bgSolid.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.widthAnchor.constraint(equalTo: view.widthAnchor),
            bottomView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -600),
            
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 600),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            hintView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hintView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hintView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hintView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            hintLabel.centerXAnchor.constraint(equalTo: hintView.centerXAnchor),
            hintLabel.centerYAnchor.constraint(equalTo: hintView.centerYAnchor),
            hintLabel.widthAnchor.constraint(equalTo: hintView.widthAnchor),
            
            closeImage.centerXAnchor.constraint(equalTo: hintView.centerXAnchor),
            closeImage.bottomAnchor.constraint(equalTo: hintView.bottomAnchor, constant: -20),
            
            hintTouchField.topAnchor.constraint(equalTo: hintView.topAnchor),
            hintTouchField.bottomAnchor.constraint(equalTo: hintView.bottomAnchor),
            hintTouchField.leadingAnchor.constraint(equalTo: hintView.leadingAnchor),
            hintTouchField.trailingAnchor.constraint(equalTo: hintView.trailingAnchor),
            
            collectionView.heightAnchor.constraint(equalTo: bottomView.heightAnchor),
            collectionView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            
            widthConstraintImagePH,
            heightConstraintImagePH,
            imagePH.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imagePH.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            
//            centerScroll.widthAnchor.constraint(equalToConstant: 40),
//            centerScroll.heightAnchor.constraint(equalToConstant: 40),
//            centerScroll.centerXAnchor.constraint(equalTo: imagePH.centerXAnchor),
//            centerScroll.centerYAnchor.constraint(equalTo: imagePH.centerYAnchor),
            
//            centerCommon.widthAnchor.constraint(equalToConstant: 25),
//            centerCommon.heightAnchor.constraint(equalToConstant: 25),
//            centerCommon.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//            centerCommon.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
        ])
    }
    
    @objc private func handleTapOnHint() {
        print("XXXXXXXXXXXXXXX")
        closeHint()
    }
    
    private func closeHint() {
        inTransition = true
        hintTimer?.invalidate()
            UIView.animate(withDuration: 0.3, animations:  {
                self.hintView.alpha = 0
                self.hintLabel.alpha = 0
                self.closeImage.alpha = 0
                
            }) { _ in
                self.hintView.isHidden = true
                self.hintLabel.isHidden = true
                self.closeImage.isHidden = true
                self.hintTouchField.isUserInteractionEnabled = false
                self.inTransition = false
            }
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
        
        if scrollView.contentSize != CGSize(width: imageViewSize.width, height: imageViewSize.height) {
            scrollView.contentSize = CGSize(width: imageViewSize.width, height: imageViewSize.height)
        }
        
        let centerX = (scrollView.contentSize.width - scrollView.bounds.width) / 2
        let centerY = (scrollView.contentSize.height - scrollView.bounds.height) / 2
        scrollView.setContentOffset(CGPoint(x: centerX, y: centerY), animated: false)
        
        widthConstraintImagePH.constant = imageViewSize.width
        heightConstraintImagePH.constant = imageViewSize.height
        
//        view.layoutIfNeeded()
    }
    
    func findCellWithID(_ id: UUID) {
        guard let index = ViewController.paintingList[currentLevel].areas.firstIndex(where: { $0.idArea == id }) else {
            return
        }
        let indexPath = IndexPath(item: index, section: 0)
        if let resultIndex = resultModel.firstIndex(where: {$0.id == id}) {
            resultModel[resultIndex].wasClicked = true
            collectionView.reloadItems(at: [indexPath])
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
//        print("Did click on zone: ", area.areaID ?? "111")
        findCellWithID(area.areaID)
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePH
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewController.paintingList[currentLevel].areas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClickableAreaCell", for: indexPath) as! ClickableAreaCell
        let dataItem = ViewController.paintingList[currentLevel].areas[indexPath.item]
        guard let resultItem = resultModel.first(where: {$0.id == dataItem.idArea}) else {
            return cell
        }
        print(resultItem.wasClicked)
        cell.configureCell(cellID: dataItem.idArea, hintText: dataItem.hintText, wasClicked: resultItem.wasClicked)
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if inTransition { return }
        hintTimer?.invalidate()
        hintView.isHidden = false
        hintLabel.isHidden = false
        closeImage.isHidden = false
        hintView.alpha = 0.8
        hintLabel.alpha = 1
        closeImage.alpha = 1
        hintLabel.text = ViewController.paintingList[currentLevel].areas[indexPath.item].hintText
        hintTouchField.isUserInteractionEnabled = true
        
        hintTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { [weak self] _ in
            self?.closeHint()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSize = collectionView.bounds.height - collectionInsets.top - collectionInsets.bottom
        return CGSize(width: sideSize, height: sideSize)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}


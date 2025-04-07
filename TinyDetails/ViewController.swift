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
    
    var imageViewSize: CGSize!
    
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
    var image: UIImage!
    var button: UIButton!
    var bottomView: UIView!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNormalLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupPictureLayout(currentLevel: currentLevel)
    }
    
    private func getImageSize(image: UIImage, scrollView: UIScrollView) -> CGSize {
        guard scrollView.frame.height > 0 else { return image.size }
        
        let multiplier = image.size.height / scrollView.frame.height
        let height = scrollView.frame.height
        let width = image.size.width / multiplier
        return CGSize(width: width, height: height)
    }
    
    @objc private func changeLevel() {
        currentLevel += 1
        setupPictureLayout(currentLevel: currentLevel)
    }
    
    private func setupNormalLayout() {
        bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        bgSolid = UIView()
        bgSolid.backgroundColor = UIColor(red: 0.18, green: 0.53, blue: 0.87, alpha: 1.00)
        bgSolid.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
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
        collectionView.register(ClickableAreaCell.self, forCellWithReuseIdentifier: "ClickableAreaCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        button = UIButton(type: .system)
        button.setTitle("CLICK", for: .normal)
        button.addTarget(self, action: #selector(changeLevel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bgSolid)
        view.addSubview(scrollView)
        view.addSubview(centerCommon)
        view.addSubview(button)
        view.addSubview(bottomView)
        bottomView.addSubview(collectionView)
        scrollView.addSubview(imagePH)
        imagePH.addSubview(centerScroll)
        
        NSLayoutConstraint.activate([
            bgSolid.widthAnchor.constraint(equalTo: view.widthAnchor),
            bgSolid.heightAnchor.constraint(equalTo: view.heightAnchor),
            bgSolid.topAnchor.constraint(equalTo: view.topAnchor),
            bgSolid.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.widthAnchor.constraint(equalTo: view.widthAnchor),
            bottomView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -600),
            
            collectionView.heightAnchor.constraint(equalTo: bottomView.heightAnchor),
            collectionView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 600),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            widthConstraintImagePH,
            heightConstraintImagePH,
            imagePH.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imagePH.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            
            centerScroll.widthAnchor.constraint(equalToConstant: 40),
            centerScroll.heightAnchor.constraint(equalToConstant: 40),
            centerScroll.centerXAnchor.constraint(equalTo: imagePH.centerXAnchor),
            centerScroll.centerYAnchor.constraint(equalTo: imagePH.centerYAnchor),
            
            centerCommon.widthAnchor.constraint(equalToConstant: 25),
            centerCommon.heightAnchor.constraint(equalToConstant: 25),
            centerCommon.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            centerCommon.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
            area.leadingAnchor.constraint(equalTo: imagePH.leadingAnchor, constant: imageViewSize.width * areaData.xPercent - CGFloat(areaData.size / 2)),
            area.topAnchor.constraint(equalTo: imagePH.topAnchor, constant: imageViewSize.height * areaData.yPercent - CGFloat(areaData.size / 2))
        ])
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
        
        view.layoutIfNeeded()
    }
}

extension ViewController: ClickableAreaDelegate {
    func didReceiveClick(area: ClickableAreaView) {
        print("Did click on zone: ", area.areaID ?? "111")
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
        cell.configureCell(cellID: dataItem.idArea, hintText: dataItem.hintText)
        
        setupClickableArea(areaData: dataItem)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(ViewController.paintingList[currentLevel].areas[indexPath.item].hintText)
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


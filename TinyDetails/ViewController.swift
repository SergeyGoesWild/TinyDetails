//
//  ViewController.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 16/03/2025.
//

import UIKit

struct ClickableArea {
    let id: Int
    let size: CGFloat
    let xPercent: CGFloat
    let yPercent: CGFloat
}

protocol ClickableAreaDelegate {
    func didReceiveClick(area: ClickableAreaView)
}

class ViewController: UIViewController {
    let areaList = [ClickableArea(id: 1, size: 80, xPercent: 0.2, yPercent: 0.4),
                    ClickableArea(id: 2, size: 80, xPercent: 0.7, yPercent: 0.1),
                    ClickableArea(id: 3, size: 80, xPercent: 0.6, yPercent: 0.8),
                    ClickableArea(id: 4, size: 80, xPercent: 0.3, yPercent: 0.6)]
    
    var bgSolid: UIView!
    var imagePH: UIImageView!
    var clickable1: UIView!
    var clickable2: UIView!
    var clickable3: UIView!
    var centerCommon: UIView!
    var centerScroll: UIView!
    var scrollView: UIScrollView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        image = UIImage(named: "SmallImage")
        imagePH = UIImageView(image: image)
        imagePH.translatesAutoresizingMaskIntoConstraints = false
        imagePH.isUserInteractionEnabled = true
        
        centerCommon = UIView()
        centerCommon.backgroundColor = .black
        centerCommon.translatesAutoresizingMaskIntoConstraints = false
        
        centerScroll = UIView()
        centerScroll.backgroundColor = .white
        centerScroll.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bgSolid)
        view.addSubview(scrollView)
        scrollView.addSubview(imagePH)
        imagePH.addSubview(centerScroll)
        view.addSubview(centerCommon)
        
        NSLayoutConstraint.activate([
            bgSolid.widthAnchor.constraint(equalTo: view.widthAnchor),
            bgSolid.heightAnchor.constraint(equalTo: view.heightAnchor),
            bgSolid.topAnchor.constraint(equalTo: view.topAnchor),
            bgSolid.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 600),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            centerCommon.widthAnchor.constraint(equalToConstant: 25),
            centerCommon.heightAnchor.constraint(equalToConstant: 25),
            centerCommon.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            centerCommon.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageViewSize = getImageSize(image: image, scrollView: scrollView)
        
        if scrollView.contentSize != CGSize(width: imageViewSize.width, height: imageViewSize.height) {
            scrollView.contentSize = CGSize(width: imageViewSize.width, height: imageViewSize.height)
        }
        
        let centerX = (scrollView.contentSize.width - scrollView.bounds.width) / 2
        let centerY = (scrollView.contentSize.height - scrollView.bounds.height) / 2
        scrollView.setContentOffset(CGPoint(x: centerX, y: centerY), animated: false)
        
        NSLayoutConstraint.activate([
            imagePH.widthAnchor.constraint(equalToConstant: imageViewSize.width),
            imagePH.heightAnchor.constraint(equalToConstant: imageViewSize.height),
            imagePH.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imagePH.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            
            centerScroll.widthAnchor.constraint(equalToConstant: 40),
            centerScroll.heightAnchor.constraint(equalToConstant: 40),
            centerScroll.centerXAnchor.constraint(equalTo: imagePH.centerXAnchor),
            centerScroll.centerYAnchor.constraint(equalTo: imagePH.centerYAnchor),
        ])
        
        for areaData in areaList {
            let area = ClickableAreaView(id: areaData.id)
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
    }
    
    func getImageSize(image: UIImage, scrollView: UIScrollView) -> CGSize {
        guard scrollView.frame.height > 0 else { return image.size }
        
        let multiplier = image.size.height / scrollView.frame.height
        let height = scrollView.frame.height
        let width = image.size.width / multiplier
        return CGSize(width: width, height: height)
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


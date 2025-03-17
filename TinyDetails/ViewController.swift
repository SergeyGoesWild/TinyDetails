//
//  ViewController.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 16/03/2025.
//

import UIKit

class ViewController: UIViewController {
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
        
        image = UIImage(named: "BigImage")
        imagePH = UIImageView(image: image)
//        imagePH.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.26, alpha: 1.00)
        imagePH.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            imagePH.widthAnchor.constraint(equalToConstant: image.size.width),
            imagePH.heightAnchor.constraint(equalToConstant: image.size.height),
            imagePH.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imagePH.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            
            centerCommon.widthAnchor.constraint(equalToConstant: 25),
            centerCommon.heightAnchor.constraint(equalToConstant: 25),
            centerCommon.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            centerCommon.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            centerScroll.widthAnchor.constraint(equalToConstant: 40),
            centerScroll.heightAnchor.constraint(equalToConstant: 40),
            centerScroll.centerXAnchor.constraint(equalTo: imagePH.centerXAnchor),
            centerScroll.centerYAnchor.constraint(equalTo: imagePH.centerYAnchor),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: imagePH.bounds.width, height: imagePH.bounds.height)
        let centerX = (scrollView.contentSize.width - scrollView.bounds.width) / 2
        let centerY = (scrollView.contentSize.height - scrollView.bounds.height) / 2
        scrollView.setContentOffset(CGPoint(x: centerX, y: centerY), animated: false)
        
        clickable1 = UIView()
        clickable1.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.24, alpha: 1.00)
        clickable1.translatesAutoresizingMaskIntoConstraints = false
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(onClick))
        clickable1.addGestureRecognizer(gesture1)
        clickable1.isUserInteractionEnabled = true
        imagePH.addSubview(clickable1)
        
        clickable2 = UIView()
        clickable2.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.24, alpha: 1.00)
        clickable2.translatesAutoresizingMaskIntoConstraints = false
//        clickable2.addGestureRecognizer(gesture1)
        clickable2.isUserInteractionEnabled = true
        imagePH.addSubview(clickable2)
        
        clickable3 = UIView()
        clickable3.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.24, alpha: 1.00)
        clickable3.translatesAutoresizingMaskIntoConstraints = false
//        clickable3.addGestureRecognizer(gesture1)
        clickable3.isUserInteractionEnabled = true
        imagePH.addSubview(clickable3)
        
        let imageViewSize = getImageSize(image: image)
        imagePH.frame.size = imageViewSize
        print(imageViewSize)
        
        NSLayoutConstraint.activate([
            clickable1.widthAnchor.constraint(equalToConstant: 100),
            clickable1.heightAnchor.constraint(equalToConstant: 100),
            clickable1.leadingAnchor.constraint(equalTo: imagePH.leadingAnchor, constant: imagePH.bounds.width * 0.1),
            clickable1.topAnchor.constraint(equalTo: imagePH.topAnchor, constant: imagePH.bounds.height * 0.1),
            
            clickable2.widthAnchor.constraint(equalToConstant: 100),
            clickable2.heightAnchor.constraint(equalToConstant: 100),
            clickable2.leadingAnchor.constraint(equalTo: imagePH.leadingAnchor, constant: imagePH.bounds.width * 0.4),
            clickable2.topAnchor.constraint(equalTo: imagePH.topAnchor, constant: imagePH.bounds.height * 0.7),
            
            clickable3.widthAnchor.constraint(equalToConstant: 100),
            clickable3.heightAnchor.constraint(equalToConstant: 100),
            clickable3.leadingAnchor.constraint(equalTo: imagePH.leadingAnchor, constant: imagePH.bounds.width * 0.85),
            clickable3.topAnchor.constraint(equalTo: imagePH.topAnchor, constant: imagePH.bounds.height * 0.85)
        ])
    }
    
    @objc func onClick() {
        print("CLICKED!")
    }
    
    func getImageSize(image: UIImage) -> CGSize {
        if image.size.width > image.size.height {
            let multiplier = image.size.height / scrollView.frame.height
            let height = scrollView.frame.height
            let width = image.size.width / multiplier
            return CGSize(width: width, height: height)
        } else {
            let multiplier = image.size.width / scrollView.frame.width
            let height = image.size.height / multiplier
            let width = scrollView.frame.width
            return CGSize(width: width, height: height)
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePH
    }
}


//
//  ViewController.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 16/03/2025.
//

import UIKit

class ViewController: UIViewController {
    var bgSolid: UIView!
    var imagePH: UIView!
    var clickable1: UIView!
    var clickable2: UIView!
    var clickable3: UIView!
    var centerCommon: UIView!
    var centerScroll: UIView!
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgSolid = UIView()
        bgSolid.backgroundColor = UIColor(red: 0.18, green: 0.53, blue: 0.87, alpha: 1.00)
        bgSolid.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        imagePH = UIView()
        imagePH.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.26, alpha: 1.00)
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
        scrollView.addSubview(centerScroll)
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
            
            imagePH.widthAnchor.constraint(equalToConstant: 1000),
            imagePH.heightAnchor.constraint(equalToConstant: 600),
            imagePH.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imagePH.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
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
        
        clickable1 = UIView()
        clickable1.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.24, alpha: 1.00)
        clickable1.translatesAutoresizingMaskIntoConstraints = false
        imagePH.addSubview(clickable1)
        
        clickable2 = UIView()
        clickable2.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.24, alpha: 1.00)
        clickable2.translatesAutoresizingMaskIntoConstraints = false
        imagePH.addSubview(clickable2)
        
        clickable3 = UIView()
        clickable3.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.24, alpha: 1.00)
        clickable3.translatesAutoresizingMaskIntoConstraints = false
        imagePH.addSubview(clickable3)
        
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
    
    @objc func onClick(number: Int) {
        print("CLICKED!")
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePH
    }
}


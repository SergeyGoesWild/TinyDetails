//
//  ClickableArea.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 18/03/2025.
//

import Foundation
import UIKit

final class ClickableAreaView: UIView {
    
//    let areaID: UUID!
    var imageView: TouchableImageView!
    weak var delegate: ClickableAreaDelegate?
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
//        self.backgroundColor = .blue
        
        imageView = TouchableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 4
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imageView.addGestureRecognizer(tapGesture)
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func handleTap() {
        delegate?.didReceiveClick(area: self)
    }
    
    func updateClickableArea(with clickableAreaData: ClickableArea) {
        guard let path = Bundle.main.path(forResource: clickableAreaData.pictureName, ofType: "png") else {
            print("Item Image not found: ", clickableAreaData.pictureName)
            return
        }
        
        let currentImage = UIImage(contentsOfFile: path)
        imageView.image = currentImage
    }
}

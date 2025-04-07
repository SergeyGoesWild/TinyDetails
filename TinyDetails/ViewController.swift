//
//  ViewController.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 16/03/2025.
//

import UIKit

struct PaintingObject {
    let idPainting: Int
    let paintingTitle: String
    let areas: [ClickableArea]
}

struct ClickableArea {
    let idArea: Int
    let size: CGFloat
    let xPercent: CGFloat
    let yPercent: CGFloat
}

protocol ClickableAreaDelegate {
    func didReceiveClick(area: ClickableAreaView)
}

class ViewController: UIViewController {
    let paintingList =
    [PaintingObject(idPainting: 1, paintingTitle: "Wave", areas:
                        [ClickableArea(idArea: 1, size: 30, xPercent: 0.2, yPercent: 0.4),
                         ClickableArea(idArea: 2, size: 30, xPercent: 0.7, yPercent: 0.1)]),
     PaintingObject(idPainting: 2, paintingTitle: "Klimt", areas:
                        [ClickableArea(idArea: 3, size: 30, xPercent: 0.6, yPercent: 0.8),
                         ClickableArea(idArea: 4, size: 30, xPercent: 0.3, yPercent: 0.6)]),
    ]
    let sideMargin: CGFloat = 16
    let collectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    var currentLevel: Int = 0
    var widthConstraintImagePH: NSLayoutConstraint!
    var heightConstraintImagePH: NSLayoutConstraint!
    
    var bgSolid: UIView!
    var imagePH: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNormalLayout()
    }
    
    private func getImageSize(image: UIImage) -> CGSize {
        let multiplier = image.size.width / view.frame.width
        let height = image.size.height / multiplier
        let width = view.frame.width
        return CGSize(width: width, height: height)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let pointInView = gesture.location(in: self.view)
        let divider = view.frame.height / imagePH.frame.height
        var percentX = pointInView.x * 100 / view.frame.width
        percentX = (percentX * 100).rounded() / 100
        var percentY = (pointInView.y - imagePH.frame.minY) * 100 / imagePH.frame.height
        percentY = (percentY * 100).rounded() / 100
        print("\(percentX) - \(percentY)")
    }
    
    private func setupNormalLayout() {
        
        bgSolid = UIView()
        bgSolid.backgroundColor = .orange
        bgSolid.translatesAutoresizingMaskIntoConstraints = false
        
        image = UIImage(named: paintingList[0].paintingTitle)
        
        imagePH = UIImageView()
        imagePH.translatesAutoresizingMaskIntoConstraints = false
        imagePH.isUserInteractionEnabled = true
        imagePH.image = image
        
        let imageSize = getImageSize(image: image)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        view.addGestureRecognizer(tapGesture)
        view.addSubview(bgSolid)
        view.addSubview(imagePH)
        
        NSLayoutConstraint.activate([
            bgSolid.widthAnchor.constraint(equalTo: view.widthAnchor),
            bgSolid.heightAnchor.constraint(equalTo: view.heightAnchor),
            bgSolid.topAnchor.constraint(equalTo: view.topAnchor),
            bgSolid.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            imagePH.widthAnchor.constraint(equalToConstant: imageSize.width),
            imagePH.heightAnchor.constraint(equalToConstant: imageSize.height),
            imagePH.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagePH.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}


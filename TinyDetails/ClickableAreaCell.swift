//
//  ClickableAreaCell.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 07/04/2025.
//

import Foundation
import UIKit

final class ClickableAreaCell: UICollectionViewCell {
    
    let bgColorGuessed = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.00)
    let bgColorNotGuessed = UIColor(red: 0.58, green: 0.65, blue: 0.65, alpha: 1.00)
    
    var cellID: UUID!
    var iconImageViewGuessed: UIImageView!
    var iconImageViewNotGuessed: UIImageView!
    var iconCheckImageView: UIImageView!
    var hintText: String!
    var iconImageGuessed: UIImage!
    var iconImageNotGuessed: UIImage!
    
    var wasClicked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = bgColorNotGuessed
        iconImageViewNotGuessed.isHidden = false
        iconImageViewGuessed.isHidden = true
        iconCheckImageView.isHidden = true
        isUserInteractionEnabled = true
    }
    
    private func setupView() {
        self.backgroundColor = bgColorNotGuessed
        self.layer.cornerRadius = 8
        self.isUserInteractionEnabled = true
        
        let config = UIImage.SymbolConfiguration(weight: .thin)
        iconImageNotGuessed = UIImage(systemName: "questionmark.square.dashed", withConfiguration: config)
        iconImageViewNotGuessed = UIImageView(image: iconImageNotGuessed)
        iconImageViewNotGuessed.tintColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00)
        iconImageViewNotGuessed.translatesAutoresizingMaskIntoConstraints = false
        iconImageViewNotGuessed.isHidden = false
        
        iconImageViewGuessed = UIImageView()
        iconImageViewGuessed.translatesAutoresizingMaskIntoConstraints = false
        iconImageViewGuessed.layer.borderWidth = 2
        iconImageViewGuessed.isHidden = true
        
        let iconCheckImage = UIImage(systemName: "checkmark.circle.fill")
        iconCheckImageView = UIImageView(image: iconCheckImage)
        iconCheckImageView.tintColor = .systemBlue
        iconCheckImageView.translatesAutoresizingMaskIntoConstraints = false
        iconCheckImageView.isHidden = true
        
        contentView.addSubview(iconImageViewNotGuessed)
        contentView.addSubview(iconImageViewGuessed)
        contentView.addSubview(iconCheckImageView)
        
        NSLayoutConstraint.activate([
            iconImageViewNotGuessed.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageViewNotGuessed.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageViewNotGuessed.widthAnchor.constraint(equalToConstant: 70),
            iconImageViewNotGuessed.heightAnchor.constraint(equalToConstant: 70),
            
            iconImageViewGuessed.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageViewGuessed.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageViewGuessed.widthAnchor.constraint(equalToConstant: 50),
            iconImageViewGuessed.heightAnchor.constraint(equalToConstant: 50),
            
            iconCheckImageView.centerXAnchor.constraint(equalTo: iconImageViewGuessed.trailingAnchor, constant: -10),
            iconCheckImageView.centerYAnchor.constraint(equalTo: iconImageViewGuessed.bottomAnchor, constant: -10),
            iconCheckImageView.widthAnchor.constraint(equalTo: iconImageViewGuessed.widthAnchor, multiplier: 0.6),
            iconCheckImageView.heightAnchor.constraint(equalTo: iconImageViewGuessed.heightAnchor, multiplier: 0.6),
        ])
    }
    
    func configureCell(dataItem: ClickableArea, wasClicked: Bool, image: UIImage) {
        self.cellID = dataItem.idArea
        self.hintText = dataItem.hintText
        self.wasClicked = wasClicked

        let scale = image.scale
        let pixelWidth = image.size.width * scale
        let pixelHeight = image.size.height * scale

        let cropSize: CGFloat = 100 * scale

        let xCoordinate = pixelWidth * dataItem.xPercent / 100
        let yCoordinate = pixelHeight * dataItem.yPercent / 100

        let cropRect = CGRect(x: xCoordinate - cropSize/2, y: yCoordinate - cropSize/2, width: cropSize, height: cropSize)

        self.iconImageGuessed = image.cropped(to: cropRect)
        changeCellState(wasClicked: wasClicked)
    }
    
    func changeCellState(wasClicked: Bool) {
        if wasClicked {
            self.backgroundColor = bgColorGuessed
            iconImageViewGuessed.image = iconImageGuessed
            iconImageViewGuessed.isHidden = false
            iconCheckImageView.isHidden = false
            iconImageViewNotGuessed.isHidden = true
            self.isUserInteractionEnabled = false
        } else {
            self.backgroundColor = bgColorNotGuessed
            iconImageViewGuessed.image = iconImageGuessed
            iconImageViewGuessed.isHidden = true
            iconCheckImageView.isHidden = true
            iconImageViewNotGuessed.isHidden = false
            self.isUserInteractionEnabled = true
        }
    }
}

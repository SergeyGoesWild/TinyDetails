//
//  ClickableAreaCell.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 07/04/2025.
//

import Foundation
import UIKit

final class ClickableAreaCell: UICollectionViewCell {
    
    var cellID: UUID!
    var iconImageView: UIImageView!
    var hintText: String!
    
    let iconImageGuessed = UIImage(named: "CheckIcon")
    let iconImageNotGuessed = UIImage(named: "QuestionIcon")
    
    var wasClicked: Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .lightGray
        iconImageView.image = iconImageNotGuessed
        isUserInteractionEnabled = true
    }
    
    private func setupView() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 8
        self.isUserInteractionEnabled = true
        iconImageView = UIImageView(image: iconImageNotGuessed)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
        ])
    }
    
    func configureCell(cellID: UUID, hintText: String, wasClicked: Bool) {
        self.cellID = cellID
        self.hintText = hintText
        self.wasClicked = wasClicked
        changeCellState(wasClicked: wasClicked)
    }
    
    func changeCellState(wasClicked: Bool) {
        if wasClicked {
            self.backgroundColor = .green
            iconImageView.image = iconImageGuessed
            self.isUserInteractionEnabled = false
        } else {
            self.backgroundColor = .lightGray
            iconImageView.image = iconImageNotGuessed
            self.isUserInteractionEnabled = true
        }
    }
}

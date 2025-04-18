//
//  ClickableArea.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 18/03/2025.
//

import Foundation
import UIKit

final class ClickableAreaView: UIView {
    
    let areaID: UUID!
    weak var delegate: ClickableAreaDelegate?
    
    init(id: UUID) {
        self.areaID = id
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .blue
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        delegate?.didReceiveClick(area: self)
    }
}

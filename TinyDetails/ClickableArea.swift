//
//  ClickableArea.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 18/03/2025.
//

import Foundation
import UIKit

final class ClickableArea: UIView {
    
    let areaID: Int!
    
    init(id: Int) {
        self.areaID = id
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
    }
}

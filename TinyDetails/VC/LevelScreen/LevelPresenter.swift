//
//  LevelPresenter.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class LevelPresenter {
    
    var model: LevelModel!
    
    var onNextStep: (() -> Void)?
    
    func provideLevel() -> PaintingObject {
        return model.shareCurrentLevel()
    }
    
    func provideArea() -> ClickableArea {
        return model.shareCurrentArea()
    }
    
    func onAreaPress() {
        if model.checkIfLevelOver() {
            // TODO: call router
        } else {
            onNextStep?()
        }
    }
    
    deinit {
        print("DEALOCATED EndLevelPresenter")
    }
}

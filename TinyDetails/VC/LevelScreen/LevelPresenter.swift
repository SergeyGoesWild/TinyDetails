//
//  LevelPresenter.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class LevelPresenter {
    
    var model: LevelModel!
    
    var onNextStep: ((ClickableArea) -> Void)?
    var onRestart: (() -> Void)?
    
    func provideLevel() -> PaintingObject {
        return model.shareCurrentLevel()
    }
    
    func provideArea() -> ClickableArea {
        return model.shareCurrentArea()
    }
    
    func provideItemIndex() -> Int {
        return model.shareItemIndex()
    }
    
    func onAreaPress() {
        if model.checkIfLevelOver() {
            if model.checkIfGameOver(){
                
            }
            onRestart?()
            // TODO: call router DEPENDING ON the game over or not
        } else {
            model.incrementAreaIndex()
            onNextStep?(provideArea())
        }
    }
    // TODO: work on onModal, onEndScreen
    
    deinit {
        print("DEALOCATED EndLevelPresenter")
    }
}

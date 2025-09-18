//
//  LevelPresenter.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class LevelPresenter {
    
    var model: LevelModel!
    
    var onNextArea: ((ClickableArea) -> Void)?
    var onNextLevel: (() -> Void)?
    
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
                model.gameReset()
                // TODO: call router with a flag
                onNextLevel?() // + delay
            } else {
                model.incrementLevelIndex()
                // TODO: call router
                onNextLevel?() // + delay
            }
            
        } else {
            model.incrementAreaIndex()
            onNextArea?(provideArea())
        }
    }
    // TODO: work on onModal, onEndScreen
    
    func onAppear() {
        model.changeScreenState()
    }
    
    deinit {
        print("DEALOCATED EndLevelPresenter")
    }
}

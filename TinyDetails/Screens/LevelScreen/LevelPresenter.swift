//
//  LevelPresenter.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class LevelPresenter {
    
    var levelModel: LevelModel
    var router: RouterProtocol
    
    var onNextArea: ((ClickableArea) -> Void)?
    var onNextLevel: (() -> Void)?
    
    init(model: LevelModel, router: RouterProtocol) {
        self.levelModel = model
        self.router = router
    }
    
    func provideLevel() -> PaintingObject {
        return levelModel.shareCurrentLevel()
    }
    
    func provideArea() -> ClickableArea {
        return levelModel.shareCurrentArea()
    }
    
    func provideItemIndex() -> Int {
        return levelModel.shareItemIndex()
    }
    
    func onAreaPress() {
        if levelModel.checkIfLevelOver() {
            if levelModel.checkIfGameOver(){
                levelModel.gameReset()
                // TODO: call router with a flag
                onNextLevel?() // + delay
            } else {
                levelModel.incrementLevelIndex()
                // TODO: call router
                onNextLevel?() // + delay
            }
            
        } else {
            levelModel.incrementAreaIndex()
            onNextArea?(provideArea())
        }
    }
    // TODO: work on onModal, onEndScreen
    
    func onAppear() {
        levelModel.changeScreenState()
    }
    
    deinit {
        print("DEALOCATED EndLevelPresenter")
    }
}

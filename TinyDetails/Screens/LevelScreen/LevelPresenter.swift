//
//  LevelPresenter.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

import UIKit

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
                router.switchAfterLevelScreen(isGameOver: true)
            } else {
                router.switchAfterLevelScreen(isGameOver: false)
            }
        } else {
            levelModel.incrementAreaIndex()
            onNextArea?(provideArea())
        }
    }
    
    func onAppear() {
        levelModel.changeScreenState()
    }
    
    func giveRefreshSignal() {
        if levelModel.checkIfGameOver(){
            levelModel.gameReset()
        } else {
            levelModel.incrementLevelIndex()
        }
        onNextLevel?()
    }
    
    deinit {
        print("DEALOCATED EndLevelPresenter")
    }
}

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
    var onTextAnimation: ((_ animated: Bool) -> Void)?
    
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
    
    func pickRightAnimation() {
        let currentLevel = levelModel.shareCurrentLevel()
        let currentItemIndex = levelModel.shareItemIndex()
        if currentItemIndex == 0 && currentLevel.tutorialData == nil {
            onTextAnimation?(false)
        } else if currentItemIndex == 0 && currentLevel.tutorialData != nil {
            print("Waiting for TUTORIAL to finish")
        } else {
            onTextAnimation?(true)
        }
    }
    
    deinit {
        print("DEALOCATED EndLevelPresenter")
    }
}

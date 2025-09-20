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
                // TODO: think of a way to change it
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.levelModel.gameReset()
                    self.onNextLevel?()
                }
            } else {
                router.switchAfterLevelScreen(isGameOver: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.levelModel.incrementLevelIndex()
                    self.onNextLevel?()
                }
            }
            
        } else {
            levelModel.incrementAreaIndex()
            onNextArea?(provideArea())
        }
    }
    
    func onAppear() {
        levelModel.changeScreenState()
    }
    
    deinit {
        print("DEALOCATED EndLevelPresenter")
    }
}

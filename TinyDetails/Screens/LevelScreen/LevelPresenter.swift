//
//  LevelPresenter.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

import UIKit

protocol LevelPresenterProtocol: AnyObject {
    var refreshLevel: () -> Void { get set }
    
    func provideLevel() -> PaintingObject
    func provideArea() -> ClickableArea
    func onAreaPress()
    func onAppear()
    func pickRightAnimation()
    func launchGame()
}

final class LevelPresenter: LevelPresenterProtocol {
    
    private var levelModel: LevelModelProtocol
    private var router: RouterProtocol
    private weak var view: LevelViewProtocol?
    
    var refreshLevel: () -> Void = { }
    
    init(model: LevelModelProtocol, router: RouterProtocol) {
        self.levelModel = model
        self.router = router
        self.refreshLevel = { [weak self] in
            self?.giveRefreshSignal()
        }
    }
    
    func attachView(view: LevelViewProtocol) {
        self.view = view
    }
    
    func launchGame() {
        view?.launchNewLevel()
    }
    
    func provideLevel() -> PaintingObject {
        return levelModel.shareCurrentLevel()
    }
    
    func provideArea() -> ClickableArea {
        return levelModel.shareCurrentArea()
    }
    
    func onAreaPress() {
        if levelModel.checkIfLevelOver() {
            if levelModel.checkIfGameOver(){
                router.afterLevel(isGameOver: true, refreshLevel: refreshLevel)
            } else {
                router.afterLevel(isGameOver: false, refreshLevel: refreshLevel)
            }
        } else {
            levelModel.incrementAreaIndex()
            view?.launchNextArea(clickableAreaData: provideArea())
        }
    }
    
    func onAppear() {
        levelModel.saveAtNewStage()
    }
    
    func giveRefreshSignal() {
        if levelModel.checkIfGameOver(){
            levelModel.gameReset()
        } else {
            levelModel.incrementLevelIndex()
        }
        view?.launchNewLevel()
    }
    
    func pickRightAnimation() {
        let currentLevel = levelModel.shareCurrentLevel()
        let currentItemIndex = levelModel.shareItemIndex()
        if currentItemIndex == 0 && currentLevel.tutorialData != nil {
            print("Wait for tutorial to end")
        } else {
            view?.showQuestion(withAnimation: true)
        }
    }
    
    deinit {
        print("DEALOCATED: LevelPresenter")
    }
}

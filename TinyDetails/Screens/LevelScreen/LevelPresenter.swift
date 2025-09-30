//
//  LevelPresenter.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

import UIKit

protocol LevelPresenterProtocol: AnyObject {
    // TODO: Maybe cleanup here too?
    var onNextArea: ((ClickableArea) -> Void)? { get set }
    var onNextLevel: (() -> Void)? { get set }
    var onTextAnimation: ((_ animated: Bool) -> Void)? { get set }
    var refreshLevel: () -> Void { get set }
    
    func provideLevel() -> PaintingObject
    func provideArea() -> ClickableArea
    func provideItemIndex() -> Int
    func onAreaPress()
    func onAppear()
    func giveRefreshSignal()
    func pickRightAnimation()
}

final class LevelPresenter: LevelPresenterProtocol {
    
    private var levelModel: LevelModelProtocol
    private var router: RouterProtocol
    
    // TODO: turn those into DI (view in init)
    // TODO: router
    // TODO: finish with protocols
    var onNextArea: ((ClickableArea) -> Void)?
    var onNextLevel: (() -> Void)?
    var onTextAnimation: ((_ animated: Bool) -> Void)?
    var refreshLevel: () -> Void = { }
    
    init(model: LevelModelProtocol, router: RouterProtocol) {
        self.levelModel = model
        self.router = router
        self.refreshLevel = { [weak self] in
            self?.giveRefreshSignal()
        }
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
                router.afterLevel(isGameOver: true, refreshLevel: refreshLevel)
            } else {
                router.afterLevel(isGameOver: false, refreshLevel: refreshLevel)
            }
        } else {
            levelModel.incrementAreaIndex()
            onNextArea?(provideArea())
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
        print("DEALOCATED: LevelPresenter")
    }
}

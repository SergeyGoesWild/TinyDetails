//
//  LevelPresenter.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

import UIKit

protocol LevelPresenterProtocol: AnyObject {
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
    
    private var textAnimationFlag: Bool = true
    
    private var updateObserver: NSObjectProtocol?
    
    init(model: LevelModelProtocol, router: RouterProtocol) {
        self.levelModel = model
        self.router = router
        
        updateObserver = NotificationCenter.default.addObserver(forName: Notification.Name("UpdateLevel"),
                                                                object: nil,
                                                                queue: .main
        ) { [weak self] _ in
            self?.textAnimationFlag = true
            self?.launchGame()
        }
    }
    
    func attachView(view: LevelViewProtocol) {
        self.view = view
    }
    
    @objc func launchGame() {
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
            router.afterLevel()
        } else {
            levelModel.incrementAreaIndex()
            view?.launchNextArea(clickableAreaData: provideArea())
        }
    }
    
    func onAppear() {
        levelModel.saveAtNewStage()
    }
    
    func pickRightAnimation() {
        let currentLevel = levelModel.shareCurrentLevel()
        let currentItemIndex = levelModel.shareItemIndex()
        if currentLevel.tutorialData != nil && currentItemIndex == 0 {
            print("Wait for tutorial to end")
        } else if currentLevel.tutorialData != nil && currentItemIndex != 0 {
            view?.showQuestion(withAnimation: true)
        } else if currentLevel.tutorialData == nil && textAnimationFlag {
            view?.showQuestion(withAnimation: false)
        } else if currentLevel.tutorialData == nil && !textAnimationFlag {
            view?.showQuestion(withAnimation: true)
        }
        textAnimationFlag = false
    }
    
    deinit {
        print("DEALOCATED: LevelPresenter")
        if let updateObserver {
            NotificationCenter.default.removeObserver(updateObserver)
        }
    }
}

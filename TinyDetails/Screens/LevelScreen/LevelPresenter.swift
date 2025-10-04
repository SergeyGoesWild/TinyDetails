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
    
    private var textFlag: Bool = true
    
    private var updateObserver: NSObjectProtocol?
    
    init(model: LevelModelProtocol, router: RouterProtocol) {
        self.levelModel = model
        self.router = router
        
        updateObserver = NotificationCenter.default.addObserver(forName: Notification.Name("UpdateLevel"),
                                                                object: nil,
                                                                queue: .main
        ) { [weak self] _ in
            self?.textFlag = true
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
            textFlag = true
            router.afterLevel()
        } else {
            textFlag = false
            levelModel.incrementAreaIndex()
            view?.launchNextArea(clickableAreaData: provideArea())
        }
    }
    
    func onAppear() {
        levelModel.saveAtNewStage()
    }
    
    func pickRightAnimation() {
        let currentLevel = provideLevel()
        
        if textFlag && currentLevel.tutorialData != nil {
            print("Skiping this part, animation comes from elsewhere")
        } else if textFlag && currentLevel.tutorialData == nil {
            view?.showQuestion(withAnimation: false)
        } else {
            view?.showQuestion(withAnimation: true)
        }
    }
    
    deinit {
        print("DEALOCATED: LevelPresenter")
        if let updateObserver {
            NotificationCenter.default.removeObserver(updateObserver)
        }
    }
}

//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

import Foundation

protocol EndLevelPresenterProtocol: AnyObject {
    func provideItem() -> PaintingObject
    func onButtonPress()
    func onAppear()
}

final class EndLevelPresenter: EndLevelPresenterProtocol {
    
    private let model: EndLevelModelProtocol
    private let router: RouterProtocol
    private var fromSave: Bool = false
    
    init(model: EndLevelModelProtocol, router: RouterProtocol, fromSave: Bool) {
        self.model = model
        self.router = router
        self.fromSave = fromSave
    }
    
    func provideItem() -> PaintingObject {
        return model.shareItem()
    }
    
    func onButtonPress() {
        var gameOver: Bool = false
        
        if model.checkIfGameOver(){
            model.gameReset()
            gameOver = true
        } else {
            model.incrementLevelIndex()
        }
        if !fromSave {
            NotificationCenter.default.post(name: Notification.Name("UpdateLevel"), object: self)
        }
        fromSave = false
        router.afterEndLevel(with: gameOver)
    }
    
    func onAppear() {
        model.saveAtNewStage()
    }
    
    deinit {
        print("DEALOCATED: EndLevelPresenter")
    }
}

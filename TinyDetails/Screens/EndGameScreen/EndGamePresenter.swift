//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class EndGamePresenter {
    
    var model: EndGameModel
    var router: RouterProtocol
    
    init(model: EndGameModel, router: RouterProtocol) {
        self.model = model
        self.router = router
    }
    
    func provideItem() -> EndGameData {
        return model.shareItem()
    }
    
    func onButtonPress() {
        router.switchAfterEndGameScreen()
    }
    
    func onAppear() {
        model.saveAtNewStage()
    }
    
    deinit {
        print("DEALOCATED: EndGamePresenter")
    }
}

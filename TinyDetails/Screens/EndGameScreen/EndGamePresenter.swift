//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

protocol EndGamePresenterProtocol: AnyObject {    
    func provideItem() -> EndGameData
    func onButtonPress()
    func onAppear()
}

final class EndGamePresenter: EndGamePresenterProtocol {
    
    private var model: EndGameModelProtocol
    private var router: RouterProtocol
    
    init(model: EndGameModelProtocol, router: RouterProtocol) {
        self.model = model
        self.router = router
    }
    
    func provideItem() -> EndGameData {
        return model.shareItem()
    }
    
    func onButtonPress() {
        router.afterEndGame()
    }
    
    func onAppear() {
        model.saveAtNewStage()
    }
    
    deinit {
        print("DEALOCATED: EndGamePresenter")
    }
}

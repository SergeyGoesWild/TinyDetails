//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

protocol EndLevelPresenterProtocol: AnyObject {
    func provideItem() -> PaintingObject
    func onButtonPress()
    func onAppear()
}

final class EndLevelPresenter: EndLevelPresenterProtocol {
    
    private let model: EndLevelModelProtocol
    private let router: RouterProtocol
    private let refreshLevel: (() -> Void)
    
    init(model: EndLevelModelProtocol, router: RouterProtocol, refreshLevel: @escaping (() -> Void)) {
        self.model = model
        self.router = router
        self.refreshLevel = refreshLevel
    }
    
    func provideItem() -> PaintingObject {
        return model.shareItem()
    }
    
    func onButtonPress() {
        router.afterEndLevel()
    }
    
    func onAppear() {
        model.saveAtNewStage()
        refreshLevel()
    }
    
    deinit {
        print("DEALOCATED: EndLevelPresenter")
    }
}

//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class EndLevelPresenter {
    
    private var model: EndLevelModel
    private var router: RouterProtocol
    private let refreshLevel: (() -> Void)
    
    init(model: EndLevelModel, router: RouterProtocol, refreshLevel: @escaping (() -> Void)) {
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

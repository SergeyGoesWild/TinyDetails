//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class EndLevelPresenter {
    
    var model: EndLevelModel
    var router: RouterProtocol
    
    init(model: EndLevelModel, router: RouterProtocol) {
        self.model = model
        self.router = router
    }
    
    func provideItem() -> PaintingObject {
        return model.shareItem()
    }
    
    func onButtonPress() {
        router.switchAfterEndLevelScreen()
    }
    
    func onAppear() {
        model.changeScreenState()
        router.refreshRoot()
    }
    
    deinit {
        print("DEALOCATED EndLevelPresenter")
    }
}

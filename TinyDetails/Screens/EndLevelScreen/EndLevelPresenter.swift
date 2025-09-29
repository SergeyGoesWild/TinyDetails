//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class EndLevelPresenter {
    
    private var model: EndLevelModel
    private var router: RouterProtocol
    private let onAppearClosure: (() -> Void)?
    
    init(model: EndLevelModel, router: RouterProtocol, onAppear: (() -> Void)? = nil) {
        self.model = model
        self.router = router
        self.onAppearClosure = onAppear
    }
    
    func provideItem() -> PaintingObject {
        return model.shareItem()
    }
    
    func onButtonPress() {
        router.switchAfterEndLevelScreen()
    }
    
    func onAppear() {
        model.changeScreenState()
        onAppearClosure?()
    }
    
    deinit {
        print("DEALOCATED EndLevelPresenter")
    }
}

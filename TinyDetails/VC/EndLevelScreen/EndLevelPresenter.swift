//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class EndLevelPresenter {
    
    var model: EndLevelModel!
    
    func provideItem() -> PaintingObject {
        return model.shareItem()
    }
    
    func onButtonPress() {
        model.nextAndSave()
        // TODO: call router
    }
    
    deinit {
        print("DEALOCATED EndLevelPresenter")
    }
}

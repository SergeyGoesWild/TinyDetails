//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class EndGamePresenter {
    
    var model: EndGameModel!
    
    func provideItem() -> EndGameData {
        return model.shareItem()
    }
    
    func onButtonPress() {
        model.nextAndSave()
        // TODO: call router
    }
    
    func onAppear() {
        model.changeScreenState()
    }
    
    deinit {
        print("DEALOCATED EndLevelPresenter")
    }
}

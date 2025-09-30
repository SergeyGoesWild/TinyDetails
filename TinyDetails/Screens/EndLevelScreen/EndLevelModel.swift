//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 11/09/2025.
//

protocol EndLevelModelProtocol: AnyObject {
    func shareItem() -> PaintingObject
    func saveAtNewStage()
}

final class EndLevelModel: EndLevelModelProtocol {
    
    private var currentItem: PaintingObject {
        get {
            let currentLevelIndex = gameStateProvider.levelIndex
            return dataProvider.paintingList[currentLevelIndex]
        }
    }
    
    private let gameStateProvider: GameStateProvider
    private let dataProvider: DataProvider
    
    init(dataProvider: DataProvider, gameStateProvider: GameStateProvider) {
        self.dataProvider = dataProvider
        self.gameStateProvider = gameStateProvider
    }
    
    func shareItem() -> PaintingObject {
        return currentItem
    }
    
    func saveAtNewStage() {
        gameStateProvider.onEndLevel = true
        gameStateProvider.onEndGame = false
    }
    
    deinit {
        print("DEALOCATED: EndLevelModel")
    }
}

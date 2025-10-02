//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 11/09/2025.
//

protocol EndLevelModelProtocol: AnyObject {
    func shareItem() -> PaintingObject
    func saveAtNewStage()
    func checkIfGameOver() -> Bool
    func gameReset()
    func incrementLevelIndex()
}

final class EndLevelModel: EndLevelModelProtocol {
    
    private var currentItem: PaintingObject {
        get {
            let currentLevelIndex = gameStateProvider.levelIndex
            return dataProvider.paintingList[currentLevelIndex]
        }
    }
    
    private var levelIndex: Int {
        get {
            gameStateProvider.levelIndex
        }
    }
    
    private let gameStateProvider: GameStateProviderProtocol
    private let dataProvider: DataProvider
    
    init(dataProvider: DataProvider, gameStateProvider: GameStateProviderProtocol) {
        self.dataProvider = dataProvider
        self.gameStateProvider = gameStateProvider
    }
    
    func shareItem() -> PaintingObject {
        return currentItem
    }
    
    func saveAtNewStage() {
        gameStateProvider.phase = .onEndLevel
    }
    
    func checkIfGameOver() -> Bool {
        if levelIndex == dataProvider.paintingList.count - 1 {
            return true
        } else {
            return false
        }
    }
    
    func gameReset() {
        gameStateProvider.resetState()
    }
    
    func incrementLevelIndex() {
        gameStateProvider.incrementLevel()
    }
    
    deinit {
        print("DEALOCATED: EndLevelModel")
    }
}

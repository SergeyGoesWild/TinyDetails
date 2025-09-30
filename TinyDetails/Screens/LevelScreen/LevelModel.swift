//
//  LevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

protocol LevelModelProtocol: AnyObject {
    // TODO: Maybe some cleanup here?
    func checkIfLevelOver() -> Bool
    func checkIfGameOver() -> Bool
    func shareCurrentLevel() -> PaintingObject
    func shareCurrentArea() -> ClickableArea
    func shareItemIndex() -> Int
    func incrementAreaIndex()
    func incrementLevelIndex()
    func gameReset()
    func saveAtNewStage()
}

final class LevelModel: LevelModelProtocol {
    
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
    
    private var areaIndex: Int {
        get {
            gameStateProvider.areaIndex
        }
    }
    
    // TODO: protocol for GameStateProvider
    private let gameStateProvider: GameStateProvider
    private let dataProvider: DataProvider
    
    init(dataProvider: DataProvider, gameStateProvider: GameStateProvider) {
        self.dataProvider = dataProvider
        self.gameStateProvider = gameStateProvider
    }
    
    func checkIfLevelOver() -> Bool {
        if areaIndex == currentItem.areas.count - 1 {
            return true
        } else {
            return false
        }
    }
    
    func checkIfGameOver() -> Bool {
        if levelIndex == dataProvider.paintingList.count - 1 {
            return true
        } else {
            return false
        }
    }
    
    func shareCurrentLevel() -> PaintingObject {
        return currentItem
    }
    
    func shareCurrentArea() -> ClickableArea {
        return currentItem.areas[areaIndex]
    }
    
    func shareItemIndex() -> Int {
        return areaIndex
    }
    
    func incrementAreaIndex() {
        gameStateProvider.incrementArea()
    }
    
    func incrementLevelIndex() {
        gameStateProvider.incrementLevel()
    }
    
    func gameReset() {
        gameStateProvider.resetState()
    }
    
    func saveAtNewStage() {
        gameStateProvider.onEndLevel = false
        gameStateProvider.onEndGame = false
    }
    
    deinit {
        print("DEALOCATED: LevelModel")
    }
}

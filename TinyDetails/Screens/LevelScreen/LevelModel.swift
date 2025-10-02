//
//  LevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

protocol LevelModelProtocol: AnyObject {
    func checkIfLevelOver() -> Bool
    func shareCurrentLevel() -> PaintingObject
    func shareCurrentArea() -> ClickableArea
    func shareItemIndex() -> Int
    func incrementAreaIndex()
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
    
    private let gameStateProvider: GameStateProviderProtocol
    private let dataProvider: DataProvider
    
    init(dataProvider: DataProvider, gameStateProvider: GameStateProviderProtocol) {
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
    
    func saveAtNewStage() {
        gameStateProvider.phase = .onLevel
    }
    
    deinit {
        print("DEALOCATED: LevelModel")
    }
}

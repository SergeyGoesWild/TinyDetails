//
//  LevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class LevelModel {
    
    private var currentItem: PaintingObject {
        get {
            let currentLevelIndex = gameStateProvider.levelIndex
            return dataProvider.paintingList[currentLevelIndex]
        }
    }
    
    private var areaIndex: Int {
        get {
            gameStateProvider.areaIndex
        }
    }
    
    let gameStateProvider: GameStateProvider
    let dataProvider: DataProvider
    
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
    
    func shareCurrentLevel() -> PaintingObject {
        return currentItem
    }
    
    func shareCurrentArea() -> ClickableArea {
        return currentItem.areas[areaIndex]
    }
    
    func incrementAreaIndex() {
        gameStateProvider.incrementArea()
    }
}

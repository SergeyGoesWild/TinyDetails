//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 11/09/2025.
//

final class EndLevelModel {
    
    // TODO: Link this
    private var currentItem: PaintingObject?
    
    let gameStateProvider: GameStateProvider
    let dataProvider: DataProvider
    
    init(dataProvider: DataProvider, gameStateProvider: GameStateProvider) {
        self.dataProvider = dataProvider
        self.gameStateProvider = gameStateProvider
        
        updateItem()
    }
    
    func updateItem() {
        let currentLevelIndex = gameStateProvider.levelIndex
        currentItem = dataProvider.paintingList[currentLevelIndex]
    }
    
    func shareItem() -> PaintingObject {
        return currentItem!
    }
    
    func nextAndSave() {
        gameStateProvider.levelIndex += 1
    }
    
    deinit {
        print("DEALOCATED EndLevelModel")
    }
}

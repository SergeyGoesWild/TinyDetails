//
//  LevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

final class LevelModel {
    
    var currentItem: PaintingObject?
    var areaIndex: Int
    var firstRound: Bool
    
    let gameStateProvider: GameStateProvider
    let dataProvider: DataProvider
    
    init(dataProvider: DataProvider, gameStateProvider: GameStateProvider) {
        self.dataProvider = dataProvider
        self.gameStateProvider = gameStateProvider
        
        areaIndex = 0
        firstRound = true
    }
    
    func fetchNextItem(levelIndex: Int) {
        currentItem = dataProvider.paintingList[levelIndex]
    }
    
    func checkIfLevelOver() -> Bool {
        if areaIndex == currentItem!.areas.count - 1 {
            return true
        } else {
            return false
        }
    }
    
    func switchToNextArea() -> ClickableArea {
        if !firstRound {
            incrementAreaIndex()
        }
        firstRound = false
        return getAreaObject()
    }
    
    func getPaintingImage() -> String {
        return currentItem!.paintingTitle
    }
    
    private func getAreaObject() -> ClickableArea {
        return currentItem!.areas[areaIndex]
    }
    
    private func incrementAreaIndex() {
        areaIndex += 1
    }
}

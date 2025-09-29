//
//  EndLevelModel.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 11/09/2025.
//

struct EndGameData {
    let title: String
    let endText: String
    let imageName: String
    let imageType: String
}

final class EndGameModel {
    
    private var endGameData: EndGameData = EndGameData(
        title: "Bravo!",
        endText:
        """
        You finished the game in style!
        Soon there will be updates and new puzzles,
        so keep an eye on those.
        Until we meet again in "Tiny Details"!
        """,
        imageName: "finalScreenOsteria",
        imageType: "png")
    
    let gameStateProvider: GameStateProvider
    
    init(gameStateProvider: GameStateProvider) {
        self.gameStateProvider = gameStateProvider
    }
    
    func shareItem() -> EndGameData {
        return endGameData
    }
    
    func saveAtNewStage() {
        gameStateProvider.onEndLevel = false
        gameStateProvider.onEndGame = true
    }
    
    deinit {
        print("DEALOCATED: EndGameModel")
    }
}

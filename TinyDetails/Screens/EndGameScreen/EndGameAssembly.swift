//
//  LevelScreenAssembly.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 18/09/2025.
//

final class EndGameAssembly {
    
    static func makeEndLevelScreen(router: RouterProtocol,
                                dataProvider: DataProvider,
                                gameStateProvider: GameStateProvider) -> EndGameVC {
        let endGameModel = EndGameModel(gameStateProvider: gameStateProvider)
        let endGamePresenter = EndGamePresenter(model: endGameModel, router: router)
        let endGameVC = EndGameVC(endGamePresenter: endGamePresenter)
        return endGameVC
    }
}

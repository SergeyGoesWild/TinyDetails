//
//  LevelScreenAssembly.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 18/09/2025.
//

final class EndLevelAssembly {
    
    static func makeEndLevelScreen(router: RouterProtocol,
                                dataProvider: DataProvider,
                                gameStateProvider: GameStateProvider) -> EndLevelVC {
        let endLevelModel = EndLevelModel(dataProvider: dataProvider, gameStateProvider: gameStateProvider)
        let endLevelPresenter = EndLevelPresenter(model: endLevelModel, router: router)
        let endLevelVC = EndLevelVC(endLevelPresenter: endLevelPresenter)
        return endLevelVC
    }
}

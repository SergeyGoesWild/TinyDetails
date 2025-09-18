//
//  LevelScreenAssembly.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 18/09/2025.
//

final class LevelAssembly {
    
    static func makeLevelScreen(router: RouterProtocol,
                                dataProvider: DataProvider,
                                gameStateProvider: GameStateProvider) -> LevelVC {
        let levelModel = LevelModel(dataProvider: dataProvider, gameStateProvider: gameStateProvider)
        let levelPresenter = LevelPresenter(model: levelModel, router: router)
        let levelVC = LevelVC(levelPresenter: levelPresenter)
        return levelVC
    }
}

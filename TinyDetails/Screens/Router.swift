//
//  Router.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 18/09/2025.
//

import UIKit

enum Route {
    case level
    case endLevel
    case endGame
}

protocol RouterProtocol {
    func afterLevel()
    func afterEndLevel(with gameOver: Bool)
    func afterEndGame()
}

final class Router: RouterProtocol {
    
    private weak var nav: UINavigationController?
    
    private var dataProvider: DataProvider
    private var gameStateProvider: GameStateProviderProtocol
    
    init(navigationController: UINavigationController, dataProvider: DataProvider, gameStateProvider: GameStateProviderProtocol) {
        self.nav = navigationController
        self.dataProvider = dataProvider
        self.gameStateProvider = gameStateProvider
    }
    
    func afterLevel() {
        route(to: .endLevel)
    }
    
    func afterEndLevel(with gameOver: Bool) {
        if gameOver {
            route(to: .endGame)
        } else {
            route(to: .level)
        }
    }
    
    func afterEndGame() {
        route(to: .level)
    }
    
    private func route(to destination: Route) {
        guard let nav else { return }
        switch destination {
        case .level:
            nav.popToRootViewController(animated: true)
        case .endLevel:
            let vc = EndLevelAssembly.makeEndLevelScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider, fromSave: false)
            nav.pushViewController(vc, animated: true)
        case .endGame:
            let vc = EndGameAssembly.makeEndGameScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider)
            nav.pushViewController(vc, animated: true)
        }
    }
    
    func loadSavedScreen() {
        guard let nav else { return }
        
        switch gameStateProvider.phase {
        case .onLevel:
            print("Loading level")
        case .onEndLevel:
            let vc = EndLevelAssembly.makeEndLevelScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider, fromSave: true)
            nav.pushViewController(vc, animated: true)
        case .onEndGame:
            let vc = EndGameAssembly.makeEndGameScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider)
            nav.pushViewController(vc, animated: true)
        }
    }
}

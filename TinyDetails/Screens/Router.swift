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
    func afterLevel(isGameOver: Bool, refreshLevel: @escaping () -> Void)
    func afterEndLevel()
    func afterEndGame()
}

final class Router: RouterProtocol {
    
    private weak var nav: UINavigationController?
    
    private var dataProvider: DataProvider
    private var gameStateProvider: GameStateProvider
    
    var gameOver: Bool = false
    var refreshLevelClosure: (() -> Void)?
    
    init(navigationController: UINavigationController, dataProvider: DataProvider, gameStateProvider: GameStateProvider) {
        self.nav = navigationController
        self.dataProvider = dataProvider
        self.gameStateProvider = gameStateProvider
    }
    
    func afterLevel(isGameOver: Bool, refreshLevel: @escaping () -> Void) {
        gameOver = isGameOver
        refreshLevelClosure = refreshLevel
        route(to: .endLevel)
    }
    
    func afterEndLevel() {
        if gameOver {
            gameOver = false
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
            let vc = EndLevelAssembly.makeEndLevelScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider, refreshLevel: refreshLevelClosure ?? { } )
            nav.pushViewController(vc, animated: true)
        case .endGame:
            let vc = EndGameAssembly.makeEndGameScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider)
            nav.pushViewController(vc, animated: true)
        }
    }
    
    func loadSaveData() {
        guard let nav else { return }
        
        switch gameStateProvider.phase {
        case .onLevel:
            print("Loading level")
        case .onEndLevel:
            let vc = EndLevelAssembly.makeEndLevelScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider, refreshLevel: refreshLevelClosure ?? { } )
            nav.pushViewController(vc, animated: true)
        case .onEndGame:
            let vc = EndGameAssembly.makeEndGameScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider)
            nav.pushViewController(vc, animated: true)
        }
    }
}

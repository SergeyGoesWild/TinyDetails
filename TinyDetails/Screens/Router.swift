//
//  Router.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 18/09/2025.
//

import UIKit

protocol RouterProtocol {
    func switchAfterLevelScreen(isGameOver: Bool)
    func switchAfterEndLevelScreen()
    func switchAfterEndGameScreen()
}

final class Router: RouterProtocol {
    
    private weak var nav: UINavigationController?
    
    let dataProvider = DataProvider()
    let gameStateProvider = GameStateProvider()
    
    var gameOver: Bool = false
    
    init(navigationController: UINavigationController) {
        self.nav = navigationController
    }
    
    func switchAfterLevelScreen(isGameOver: Bool) {
        gameOver = isGameOver
        goEndLevel()
    }
    
    func switchAfterEndLevelScreen() {
        if gameOver {
            gameOver = false
            goEndGame()
        } else {
            goNextLevel()
        }
    }
    
    func switchAfterEndGameScreen() {
        goNextLevel()
    }
    
    private func goEndLevel() {
        guard let nav else { return }
        let vc = EndLevelAssembly.makeEndLevelScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider)
        nav.pushViewController(vc, animated: true)
    }
    
    private func goEndGame() {
        guard let nav else { return }
        let vc = EndGameAssembly.makeEndGameScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider)
        nav.pushViewController(vc, animated: true)
    }
    
    private func goNextLevel(animated: Bool = true) {
        nav?.popToRootViewController(animated: animated)
    }
}

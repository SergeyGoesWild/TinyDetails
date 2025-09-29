//
//  Router.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 18/09/2025.
//

import UIKit

protocol RouterProtocol {
    func switchAfterLevelScreen(isGameOver: Bool, refreshLevel: @escaping () -> Void)
    func switchAfterEndLevelScreen()
    func switchAfterEndGameScreen()
}

final class Router: RouterProtocol {
    
    private weak var nav: UINavigationController?
    private weak var rootPresenter: LevelPresenter?
    
    private var dataProvider: DataProvider
    private var gameStateProvider: GameStateProvider
    
    var gameOver: Bool = false
    var refreshLevelClosure: (() -> Void)?
    
    init(navigationController: UINavigationController, dataProvider: DataProvider, gameStateProvider: GameStateProvider) {
        self.nav = navigationController
        self.dataProvider = dataProvider
        self.gameStateProvider = gameStateProvider
    }
    
    func switchAfterLevelScreen(isGameOver: Bool, refreshLevel: @escaping () -> Void) {
        gameOver = isGameOver
        refreshLevelClosure = refreshLevel
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
        let vc = EndLevelAssembly.makeEndLevelScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider, onAppear: refreshLevelClosure!)
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

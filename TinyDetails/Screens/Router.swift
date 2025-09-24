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
    func refreshRoot()
}

final class Router: RouterProtocol {
    
    private weak var nav: UINavigationController?
    private weak var rootPresenter: LevelPresenter?
    
    private var dataProvider: DataProvider
    private var gameStateProvider: GameStateProvider
    
    var gameOver: Bool = false
    
    init(navigationController: UINavigationController, dataProvider: DataProvider, gameStateProvider: GameStateProvider) {
        self.nav = navigationController
        self.dataProvider = dataProvider
        self.gameStateProvider = gameStateProvider
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
    
    func refreshRoot() {
        rootPresenter?.giveRefreshSignal()
    }
    
    func setRootPresenter(rootPresenter: LevelPresenter? = nil) {
        self.rootPresenter = rootPresenter
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

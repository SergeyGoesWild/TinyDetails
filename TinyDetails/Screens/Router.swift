//
//  Router.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 18/09/2025.
//

import UIKit

protocol RouterProtocol {
    
}

final class Router: RouterProtocol {
    
    private weak var nav: UINavigationController?
    
    let dataProvider = DataProvider()
    let gameStateProvider = GameStateProvider()
    
    var gameOver: Bool = false
    
    init(navigationController: UINavigationController) {
        self.nav = navigationController
    }
    
    func goNextScreen() {
        if gameOver {
            goEndGame()
        } else {
            popToRoot()
        }
    }
    
    func setGameOverFlag() {
        gameOver = true
    }
    
    func goEndLevel() {
        guard let nav else { return }
        let vc = EndLevelAssembly.makeEndLevelScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider)
        nav.pushViewController(vc, animated: true)
    }
    
    func goEndGame() {
        guard let nav else { return }
        let vc = EndGameAssembly.makeEndGameScreen(router: self, dataProvider: dataProvider, gameStateProvider: gameStateProvider)
        nav.pushViewController(vc, animated: true)
    }
    
    func popToRoot(animated: Bool = true) {
        nav?.popToRootViewController(animated: animated)
    }
    
//    private func make(route: Route) -> UIViewController {
//        switch route {
//        case .screen1:
//            return ModuleBuilder.makeScreen1(router: self, services: services)
//            
//        case .screen2(let input):
//            return ModuleBuilder.makeScreen2(input: input, router: self, services: services)
//            
//        case .screen3:
//            return ModuleBuilder.makeScreen3(router: self, services: services)
//        }
//    }
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        setupGameComponent()
    //    }
    //
    //    private func setupGameComponent() {
    //        navController = UINavigationController(rootViewController: gameVC)
    //        navController.setNavigationBarHidden(true, animated: false)
    //        addChild(navController)
    //        view.addSubview(navController.view)
    //        navController.view.translatesAutoresizingMaskIntoConstraints = false
    //
    //        NSLayoutConstraint.activate([
    //            navController.view.topAnchor.constraint(equalTo: view.topAnchor),
    //            navController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    //            navController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    //            navController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    //        ])
    //
    //        navController.didMove(toParent: self)
    //    }
}

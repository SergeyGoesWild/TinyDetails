//
//  SaveProvider.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 01/07/2025.
//
import UIKit

final class SaveProvider {
    static let shared = SaveProvider()
    
    private init() {}
    
    var hasSeenTutorial: Bool {
        get { UserDefaults.standard.bool(forKey: "hasSeenTutorial") }
        set { UserDefaults.standard.set(newValue, forKey: "hasSeenTutorial") }
    }
    
    var latestLevelIndex: Int {
        get { UserDefaults.standard.integer(forKey: "latestLevelIndex") }
        set { UserDefaults.standard.set(newValue, forKey: "latestLevelIndex") }
    }
    
    var latestItemIndex: Int {
        get { UserDefaults.standard.integer(forKey: "latestItemIndex") }
        set { UserDefaults.standard.set(newValue, forKey: "latestItemIndex")}
    }
    
    var onModal: Bool {
        get { UserDefaults.standard.bool(forKey: "onModal") }
        set { UserDefaults.standard.set(newValue, forKey: "onModal")}
    }
    
    var onEndScreen: Bool {
        get { UserDefaults.standard.bool(forKey: "onEndScreen") }
        set { UserDefaults.standard.set(newValue, forKey: "onEndScreen")}
    }
}

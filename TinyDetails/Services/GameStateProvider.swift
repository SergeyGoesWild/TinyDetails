//
//  GameStateProvider.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

import Foundation

final class GameStateProvider {
    
    struct GameStateData: Codable {
        var levelIndex: Int = 0
        var areaIndex: Int = 0
        var onModal: Bool = false
        var onEndScreen: Bool = false
    }
    
    private var currentStateData = GameStateData() {
        didSet {
            saveData()
        }
    }
    
    var levelIndex: Int {
        get { currentStateData.levelIndex }
        set { currentStateData.levelIndex = newValue }
    }
    
    var areaIndex: Int {
        get { currentStateData.areaIndex }
        set { currentStateData.areaIndex = newValue }
    }
    
    var onEndLevel: Bool {
        get { currentStateData.onModal }
        set { currentStateData.onModal = newValue }
    }
    
    var onEndGame: Bool {
        get { currentStateData.onEndScreen }
        set { currentStateData.onEndScreen = newValue }
    }
    
    private let saveFileName = "TinyDetails_SaveFile_v1.json"
    private lazy var saveFileURL: URL = {
        do {
            let docsDir = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return docsDir.appendingPathComponent(saveFileName)
        } catch {
            fatalError("CRITICAL: Failed to access Documents directory - \(error)")
        }
    }()
    
    private func saveData() {
        do {
            let data = try JSONEncoder().encode(currentStateData)
            try data.write(to: saveFileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    private func loadData() {
        guard FileManager.default.fileExists(atPath: saveFileURL.path) else { return }
        
        do {
            let data = try Data(contentsOf: saveFileURL)
            currentStateData = try JSONDecoder().decode(GameStateData.self, from: data)
        } catch {
            print("Failed to load save data: \(error)")
            currentStateData = GameStateData()
        }
    }
    
    func provideGameState() -> GameStateData {
        loadData()
        return currentStateData
    }
    
    func incrementLevel() {
        levelIndex += 1
        areaIndex = 0
    }
    
    func incrementArea() {
        areaIndex += 1
    }
    
    func resetState() {
        levelIndex = 0
        areaIndex = 0
        onEndLevel = false
        onEndGame = false
    }
}

//
//  GameStateProvider.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

import Foundation

enum AppPhase: Encodable, Decodable {
    case onLevel
    case onEndLevel
    case onEndGame
}

final class GameStateProvider {
    
    struct GameStateData: Encodable, Decodable {
        var levelIndex: Int = 0
        var areaIndex: Int = 0
        var phase: AppPhase = .onLevel
    }
    
    // TODO: optimise + protocol for GameStateProvider
    // TODO: router optimise (related to GameStateProvider)
    // TODO: save load (loading from some screen other than the main one)
    
    static let shared = GameStateProvider()
    private init() {
        self.loadData()
//        gameStateProvider.resetState()
    }
    
    private var currentStateData = GameStateData() {
        didSet {
            saveData()
            print("--")
            print("-------")
            print(currentStateData)
            print("-------")
            print("--")
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
    
    var phase: AppPhase {
        get { currentStateData.phase }
        set { currentStateData.phase = newValue }
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
            print("Saving...")
            let data = try JSONEncoder().encode(currentStateData)
            try data.write(to: saveFileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    func loadData() {
        guard FileManager.default.fileExists(atPath: saveFileURL.path) else { return }
        
        do {
            print("Loading...")
            let data = try Data(contentsOf: saveFileURL)
            currentStateData = try JSONDecoder().decode(GameStateData.self, from: data)
        } catch {
            print("Failed to load save data: \(error)")
            currentStateData = GameStateData()
        }
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
        phase = .onLevel
    }
}

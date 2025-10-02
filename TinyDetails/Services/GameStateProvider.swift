//
//  GameStateProvider.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 10/09/2025.
//

import Foundation

protocol GameStateProviderProtocol: AnyObject {
    var levelIndex: Int { get set }
    var areaIndex: Int { get set }
    var phase: AppPhase { get set }
    
    func incrementLevel()
    func incrementArea()
    func resetState()
}

enum AppPhase: Encodable, Decodable {
    case onLevel
    case onEndLevel
    case onEndGame
}

final class GameStateProvider: GameStateProviderProtocol {
    
    struct GameStateData: Encodable, Decodable {
        var levelIndex: Int = 0
        var areaIndex: Int = 0
        var phase: AppPhase = .onLevel
    }
    
    let savingActive: Bool = true
    
    static let shared = GameStateProvider()
    private init() {
        if savingActive { self.loadData() }
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
            let data = try JSONEncoder().encode(currentStateData)
            try data.write(to: saveFileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    func loadData() {
        guard FileManager.default.fileExists(atPath: saveFileURL.path) else { return }
        
        do {
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

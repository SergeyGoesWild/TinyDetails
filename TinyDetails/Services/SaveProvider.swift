//
//  SaveProvider.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 01/07/2025.
//
import Foundation

final class SaveProvider {
    static let shared = SaveProvider()
    
    private let saveFileName = "game_save_v2.json"
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
    
    private struct GameData: Codable {
        var latestLevelIndex: Int = 0
        var latestItemIndex: Int = 0
        var onModal: Bool = false
        var onEndScreen: Bool = false
    }
    
    private var currentData = GameData() {
        didSet {
            saveCurrentData()
        }
    }
    
    private init() {
        loadInitialData()
        print("Save file location: \(saveFileURL.path)")
    }
    
    var latestLevelIndex: Int {
        get { currentData.latestLevelIndex }
        set { currentData.latestLevelIndex = newValue }
    }
    
    var latestItemIndex: Int {
        get { currentData.latestItemIndex }
        set { currentData.latestItemIndex = newValue }
    }
    
    var onModal: Bool {
        get { currentData.onModal }
        set { currentData.onModal = newValue }
    }
    
    var onEndScreen: Bool {
        get { currentData.onEndScreen }
        set { currentData.onEndScreen = newValue }
    }
    
    // MARK: - Data Operations
    private func loadInitialData() {
        guard FileManager.default.fileExists(atPath: saveFileURL.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: saveFileURL)
            currentData = try JSONDecoder().decode(GameData.self, from: data)
        } catch {
            print("Failed to load save data: \(error)")
            currentData = GameData()
        }
    }
    
    private func saveCurrentData() {
        do {
            let data = try JSONEncoder().encode(currentData)
            try data.write(to: saveFileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    func printSaveLocation() {
        print("Save file location: \(saveFileURL.path)")
    }
    
    func resetAllData() {
        currentData = GameData()
    }
    
    func deleteSaveFile() {
        do {
            try FileManager.default.removeItem(at: saveFileURL)
            currentData = GameData()
        } catch {
            print("Failed to delete save file: \(error)")
        }
    }
}

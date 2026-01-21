//
//  Init.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2025-12-24.
//

import ArgumentParser
import Foundation

/// Commands related to initializing Trak and setting up local storage
extension Trak {
    
    /// Initializes Trak by creating the required file system structure.
    ///
    /// This command must be run once before any other Trak command.
    /// It sets up the application support directories uses for subject, sessions and other persisted data
    struct Init : ParsableCommand{
        
        static let configuration = CommandConfiguration(
            abstract: "Initialize trak and set up file storage",
            usage: "trak init",
            discussion: "Ensure you run this command once before running any other commands",
            shouldDisplay: true
        )
        
        /// Excecutes the initialization process.
        ///
        /// This notifies the `DataManager` to create the required directories
        /// - Throws:`ExitCode.Failure` if `StorageError` is caught
        func run() throws {
            do {
                CLI.printHeader("Initialize Trak")
                try TrakApp.dataManager.setupDataStorage()
                CLI.printSuccess("Trak storage initialized.")
            } catch let err as LocalizedError {
                CLI.printError(err.errorDescription ?? "Initialization failed.")
                throw ExitCode.failure
            } catch {
                CLI.printError("Unexpected error: \(error)")
                throw ExitCode.failure
            }
        }
    }
}


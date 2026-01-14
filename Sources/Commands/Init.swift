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
        func run() throws{
            do {
                try TrakApp.dataManager.setupDataStorage()
                print ("\nTrak storage initialized.\n")
            }
            catch let err as StorageError{
                print(err.localizedDescription)
                throw ExitCode.failure
            }
        }
    }
}


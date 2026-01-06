//
//  Init.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2025-12-24.
//

/*
 The init command sets up data storage needed
 */
import ArgumentParser
import Foundation

extension Trak {
    struct Init : ParsableCommand{
        
        static let configuration = CommandConfiguration(
            abstract: "Initialize trak and set up file storage",
            usage: "trak init",
            discussion: "Ensure you run this command once before running any other commands",
            shouldDisplay: true
        )
        
        
        func run() throws{
            //Use <dataManager> from <TrakApp> setup user storage
            do {
                try TrakApp.dataManager.setupDataStorage()
                print ("Trak storage initialized.")
            }
            catch let err as StorageError{
                print(err.localizedDescription)
                throw ExitCode.failure //Program terminates immediately
            }
            
        }
    }
}


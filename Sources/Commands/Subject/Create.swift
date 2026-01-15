//
//  Create.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-14.
//
import Foundation
import ArgumentParser

extension Trak.Subject {
    
    /// Create a new subject
    struct Create : ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Create a new subject"
        )
        
        @Argument(help: "The name of the subject")
        var name: String
        
        /// Execute the create command
        func run() throws {
            do {
                try TrakApp.subjectManager.createSubject(name: name)
                print("New subject \(name) created.")
            } catch let err as StorageError{
                print (err.localizedDescription)
                throw ExitCode.failure
            }
        }
    }
}

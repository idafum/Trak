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
                CLI.printHeader("Create Subject")
                try TrakApp.subjectManager.createSubject(name: name)
                CLI.printSuccess("New subject '\(name)' created.")
            } catch let err as LocalizedError {
                CLI.printError(err.errorDescription ?? "Failed to create subject.")
                throw ExitCode.failure
            } catch {
                CLI.printError("Unexpected error: \(error)")
                throw ExitCode.failure
            }
        }
    }
}

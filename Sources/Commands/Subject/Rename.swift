//
//  Rename.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-14.
//
import Foundation
import ArgumentParser

extension Trak.Subject {
    
    struct Rename: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Rename a subject"
        )
        
        @Argument(help: "The old name")
        var oldName: String
        
        @Argument(help: "The new name")
        var newName: String
        
        func run () throws {
            do {
                CLI.printHeader("Rename Subject")
                try TrakApp.subjectManager.renameSubject(oldName, newName)
                CLI.printSuccess("Renamed '\(oldName)' to '\(newName)'.")
            } catch let err as LocalizedError {
                CLI.printError(err.errorDescription ?? "Failed to rename subject.")
                throw ExitCode.failure
            } catch {
                CLI.printError("Unexpected error: \(error)")
                throw ExitCode.failure
            }
        }
    }
}

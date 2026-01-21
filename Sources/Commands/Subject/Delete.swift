//
//  Delete.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-14.
//

import Foundation
import ArgumentParser

extension Trak.Subject {
    struct Delete : ParsableCommand {
        static let configuration = CommandConfiguration (
            abstract: "Delete a subject"
        )
        
        @Argument(help: "The name of the subject to delete")
        var name: String
        
        func run () throws {
            do {
                CLI.printHeader("Delete Subject")
                try TrakApp.subjectManager.deleteSubject(name)
                CLI.printSuccess("'\(name)' deleted.")
            } catch let err as LocalizedError {
                CLI.printError(err.errorDescription ?? "Failed to delete subject.")
                throw ExitCode.failure
            } catch {
                CLI.printError("Unexpected error: \(error)")
                throw ExitCode.failure
            }
        }
    }
}

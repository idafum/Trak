//
//  Start.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-11.
//
import Foundation
import ArgumentParser

extension Trak.Session {
    struct Start : ParsableCommand {
        
        static let configuration = CommandConfiguration (
            abstract: "Start a new session"
        )
        
        @Argument(help: "The subject of the session")
        var subject: String
        
        func run() throws {
            do {
                CLI.printHeader("Start Session")
                try TrakApp.sessionManager.startSession(on: subject)
                CLI.printSuccess("Now tracking '\(subject)'.")
            } catch let err as LocalizedError {
                CLI.printError(err.errorDescription ?? "Failed to start session.")
                throw ExitCode.failure
            } catch {
                CLI.printError("Unexpected error: \(error)")
                throw ExitCode.failure
            }
        }
    }
}

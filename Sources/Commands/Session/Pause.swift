//
//  Pause.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-16.
//

import ArgumentParser
import Foundation
extension Trak.Session {
    struct Pause : ParsableCommand {
        static let configuration = CommandConfiguration (
            abstract: "Pause a running session"
        )
        
        func run() throws {
            do {
                CLI.printHeader("Pause Session")
                guard let session = try TrakApp.sessionManager.pauseSession() else {
                    CLI.printInfo("No session running.")
                    throw ExitCode.failure
                }
                CLI.printSuccess("Paused '\(session.subjectName)'.")
            } catch let err as LocalizedError {
                CLI.printError(err.errorDescription ?? "Failed to pause session.")
                throw ExitCode.failure
            } catch {
                CLI.printError("Unexpected error: \(error)")
                throw ExitCode.failure
            }
        }
    }
}

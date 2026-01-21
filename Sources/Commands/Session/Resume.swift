//
//  Resume.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-17.
//

import Foundation
import ArgumentParser

extension Trak.Session {
    struct Resume : ParsableCommand {
        static let configuration = CommandConfiguration (
            abstract: "Resume a paused session."
        )
        
        func run() throws {
            do {
                CLI.printHeader("Resume Session")
                guard let session = try TrakApp.sessionManager.resumeSession() else {
                    CLI.printInfo("No session found.")
                    throw ExitCode.failure
                }
                CLI.printSuccess("Resumed '\(session.subjectName)'.")
            } catch let err as LocalizedError {
                CLI.printError(err.errorDescription ?? "Failed to resume session.")
                throw ExitCode.failure
            } catch {
                CLI.printError("Unexpected error: \(error)")
                throw ExitCode.failure
            }
        }
    }
}

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
                try TrakApp.sessionManager.startSession(on: subject)
                print("Now tracking `\(subject)`...")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

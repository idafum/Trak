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
        
        func run() throws {
            
        }
    }
}

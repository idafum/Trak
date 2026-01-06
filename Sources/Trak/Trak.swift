//
//  Trak.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2025-12-21.
//

import Figlet
import ArgumentParser
import Foundation

@main
struct Trak: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "trak",
        version: "0.1.0",
        shouldDisplay: true,
        subcommands: [Init.self, Subject.self]
    )
    
    func run() {
        Figlet.say("Trak!")
        print(Trak.helpMessage())
    }
}

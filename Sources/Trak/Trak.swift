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

    @OptionGroup var global : GlobalOptions
    
    static let configuration = CommandConfiguration(
        commandName: "trak",
        version: "0.1.0",
        shouldDisplay: true,
        subcommands: [Init.self, Subject.self, Session.self, Report.self]
    )
    
    //Run preflight. Trak has to be initialized
    mutating func validate() throws {
        try global.preflight()
    }
    
    func run() {
        Figlet.say("Trak!")
        print(Trak.helpMessage())
    }
}

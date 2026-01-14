//
//  GlobalOptions.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-14.
//

import Foundation
import ArgumentParser

struct GlobalOptions : ParsableArguments {
    
    func preflight() throws {
        
        //let trak init run
        let args = CommandLine.arguments.dropFirst()
        if let first = args.first, first == "init" { return }
        
        if !DataManager.isInitialized(appName: TrakApp.appName) {
            throw ValidationError("""
                Trak isn't initialized yet.
                
                Run `trak init`
                
                """)
        }
    }
}


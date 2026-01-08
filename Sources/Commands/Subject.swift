//
//  Subject.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-03.
//

import ArgumentParser
import Foundation

extension Trak {
    struct Subject : ParsableCommand {
        
        static let configuration = CommandConfiguration(
            commandName: "subject",
            abstract: "Manage your subjects",
            shouldDisplay: true,
            subcommands: [Create.self, List.self]
            
        )
        
        func run() throws {
            print(Subject.helpMessage())
        }
        
    }
}

extension Trak.Subject {
    struct Create : ParsableCommand {
        
        static let configuration = CommandConfiguration(
            abstract: "Create a new subject"
        )
        
        @Argument
        var name: String
        
        func run() throws {
            //Use <dataManger> from <TrakApp> to create a new file with <filename>
            //If file does exitst already, stop creation and inform us that that file already exists. Maybe then show command to List all subjects?
            
            do {
                try TrakApp.dataManager.createSubject(fileName: name)
                print("New subject \(name) created.")
            }
            catch StorageError.fileAlreadyExists(url: let url){
                print("oops '\(url.lastPathComponent)' already exists.")
                print("Use 'trak subject list' to list all subjects.")
                throw ExitCode.failure
            }
        }
        
    }
}

extension Trak {
    struct List : ParsableCommand {
        static let configuration = CommandConfiguration (
            abstract: "List all subjects"
        )
        
        func run() throws {
            //Use <dataManager> from <TrakApp> to list all Subjects
            do {
                let subjects: [String] = try TrakApp.dataManager.listSubjects()
                print (subjects)
                //TODO: Display strings in a list form for user
                //TODO: Add a signal text to start a subject session
            }
            catch StorageError.failedToGetDirectoryContents(_: let url, underlying: let underlying){
                print("Error accessing file system at \(url): \(underlying)")
                throw ExitCode.failure
            }
        }
    }

}

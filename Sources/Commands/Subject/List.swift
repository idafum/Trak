//
//  List.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-14.
//
import Foundation
import ArgumentParser
extension Trak.Subject {
    struct List : ParsableCommand {
        static let configuration = CommandConfiguration (
            abstract: "List all subjects"
        )
        
        func run() throws {
            do {
                let subjects: [SubjectData] = try TrakApp.subjectManager.listSubjects()
                
                if subjects.isEmpty {
                    print ("""
                        No subjects found
                        Use: `trak subject create <name>` to create a new subject.
                        """)
                } else {
                    print (subjects.map(\.name).joined(separator: "\n"))
                }
                
                //TODO: Display strings in a list form for user (Acceptance Criteria)
                //TODO: Add a signal text to start a subject session (Acceptance Criteria)
            }
            catch let err as StorageError{
                print (err.localizedDescription)
                throw ExitCode.failure
            }
        }
    }

}

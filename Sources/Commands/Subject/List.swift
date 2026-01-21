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
                CLI.printHeader("Subjects")
                let subjects: [SubjectData] = try TrakApp.subjectManager.listSubjects()
                if subjects.isEmpty {
                    CLI.printInfo("No subjects found. Use: trak subject create <name>")
                } else {
                    for subject in subjects.map(\.name) {
                        CLI.printKeyValue(subject, "")
                    }
                    CLI.printSuccess("Listed \(subjects.count) subject(s).")
                }
            } catch let err as LocalizedError {
                CLI.printError(err.errorDescription ?? "Failed to list subjects.")
                throw ExitCode.failure
            } catch {
                CLI.printError("Unexpected error: \(error)")
                throw ExitCode.failure
            }
        }
    }

}

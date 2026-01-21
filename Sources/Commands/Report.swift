//
//  Report.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-21.
//


import Foundation
import ArgumentParser

extension Trak {
    struct Report : ParsableCommand {
        static let configuration: CommandConfiguration = CommandConfiguration (
            abstract: "Generate a report of your current progress"
        )
        
        func run() throws {
            //tell the sessionManager to get log
            do {
                let reports = try TrakApp.sessionManager.getReports()
                if reports.isEmpty {
                    print("No session logs found.")
                } else {
                    for (subject, time) in reports.sorted(by: { $0.key < $1.key }) {
                        print("\(subject): \(time) seconds")
                    }
                }
            }
            catch {
                fputs("Failed to generate report: \(error)\n", stderr)
            }
        }
    }
}

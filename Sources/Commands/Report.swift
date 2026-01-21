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
                CLI.printHeader("Report")
                let reports = try TrakApp.sessionManager.getReports()
                if reports.isEmpty {
                    CLI.printInfo("No session logs found.")
                } else {
                    for (subject, time) in reports.sorted(by: { $0.key < $1.key }) {
                        CLI.printTrakTime(subject: subject, seconds: time)
                    }
                    CLI.printSuccess("Report generated.")
                }
            } catch {
                if let localized = error as? LocalizedError, let message = localized.errorDescription {
                    CLI.printError(message)
                } else {
                    CLI.printError("Unexpected error: \(error)")
                }
            }
        }
    }
}

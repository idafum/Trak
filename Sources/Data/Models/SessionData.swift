//
//  sessionData.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-10.
//

import Foundation

struct SessionData : Codable{
    let subjectName: String
    let startTime: Date
    let pausedAt: Date?
    let totalPausedDuration: TimeInterval
    let state: SessionState
}

extension SessionData {
    var elapsedInterval: TimeInterval {
        -startTime.timeIntervalSinceNow
    }
    
    var elapsedDisplay: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: elapsedInterval) ?? "0m"
    }
}


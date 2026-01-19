//
//  SessionLogData.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-18.
//

import Foundation
struct SessionLogData : Codable{
    var subjectName: String
    var totalElapsedTime: TimeInterval
    var totalPausedTime: TimeInterval
    var trakTime: TimeInterval
}

extension SessionLogData {
    
    var trakTimeDisplay: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: trakTime) ?? "0m"
    }
}

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


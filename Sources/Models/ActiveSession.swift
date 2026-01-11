//
//  sessionData.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-10.
//

import Foundation

struct ActiveSession : Codable{
    let subject: String
    let startTime: Date
    let pausedAt: Data?
    let totalPausedDuration: TimeInterval
    let state: SessionState
    
}


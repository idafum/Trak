//
//  NameNormalizer.swift
//  Trak
//
//  Created by Somtochukwu Idafum on 2026-01-14.
//

import Foundation

enum NameNormalizer {
    static func normalize(_ name: String) -> String {
        name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: " ", with: "_")
    }
}

//
//  BookSummaryState.swift
//  AudioBook
//
//  Created by Kseniia Piskun on 20.04.2024.
//

import Foundation

struct BookSummaryState: Equatable {
    var isPlaying = false
    var currentChapter = 1
    var totalChapters = 10
    var playbackSpeed: Double = 1.0
    var playbackPosition: Double = 0.0
    var totalDuration: Double = 0.0
    var sliderValue: Double = 0.0

    var playbackPositionString: String {
        return formatTime(seconds: playbackPosition)
    }

    var totalDurationString: String {
        return formatTime(seconds: totalDuration)
    }

    private func formatTime(seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

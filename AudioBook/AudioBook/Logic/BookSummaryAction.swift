//
//  BookSummaryAction.swift
//  AudioBook
//
//  Created by Kseniia Piskun on 20.04.2024.
//

import Foundation

enum BookSummaryAction: Equatable {
    case togglePlayPause
    case updateTotalDuration(Double)
    case updatePosition(Double)
    case seekToPosition(Double)
    case setPlaybackSpeed(Double)
    case previousChapter
    case nextChapter
    case pause
    case play
    case updateSliderValue(Double)
    case loadSummary
    case sliderValueChanged(Double)
    case updateTotalChaptersCount(Int)
}

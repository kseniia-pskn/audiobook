//
//  BookSummaryReducer.swift
//  AudioBook
//
//  Created by Kseniia Piskun on 18.04.2024.
//
//
import ComposableArchitecture
import CoreMedia

struct BookSummaryReducer: Reducer {
    typealias State = BookSummaryState
    typealias Action = BookSummaryAction
    var environment: BookSummaryEnvironment

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .togglePlayPause:
            state.isPlaying.toggle()
            return state.isPlaying ? Effect.run { _ in self.environment.player?.play() }
                                   : Effect.run { _ in self.environment.player?.pause() }
        case .play:
            state.isPlaying = true
            return Effect.run { _ in self.environment.player?.play() }
        case .pause:
            state.isPlaying = false
            return Effect.run { _ in self.environment.player?.pause() }
        case .updateTotalDuration(let duration):
            state.totalDuration = duration
            return .none
        case .updatePosition(let position):
            state.playbackPosition = position
            return .none
        case .seekToPosition(let position):
            return Effect.run { _ in self.environment.player?.seek(to: CMTime(seconds: position, preferredTimescale: 600)) }
        case .updateSliderValue(let value):
            state.sliderValue = value
            if !state.isPlaying {
                let newPosition = value * state.totalDuration
                return Effect.run { _ in self.environment.player?.seek(to: CMTime(seconds: newPosition, preferredTimescale: 600)) }
            }
            return .none
        case .setPlaybackSpeed(let speed):
            state.playbackSpeed = speed
            return Effect.run { _ in self.environment.player?.rate = Float(speed) }
        case .loadSummary:
            return .none
        case .nextChapter:
            state.currentChapter += 1
            state.currentChapter = min(state.currentChapter, state.totalChapters - 1)
            return .none
        case .previousChapter:
            state.currentChapter -= 1
            state.currentChapter = max(state.totalChapters, 0)
            return .none
        case .updateTotalChaptersCount(let count):
            return .none
        case .sliderValueChanged(let newValue):
            state.sliderValue = newValue
            let newPosition = newValue * state.totalDuration
            return Effect.run {send in
                self.environment.seek(to: newPosition)
            }
        }
    }
}

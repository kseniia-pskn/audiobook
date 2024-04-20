//
//  BookSummaryEnvironment.swift
//  AudioBook
//
//  Created by Kseniia Piskun on 20.04.2024.
//

import AVFoundation
import ComposableArchitecture

class BookSummaryEnvironment: NSObject {
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var playerItems: [AVPlayerItem] = []
    var timeObserverToken: Any?
    var store: Store<BookSummaryState, BookSummaryAction>?
    var sendAction: ((BookSummaryAction) -> Void)?

    override init() {
        super.init()
        setupAudioSession()
        loadAudioTrack()
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session.")
        }
    }
    
    func loadAudioTrack() {
        let trackNames = ["lullaby"]
        playerItems = trackNames.compactMap { name in
            guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return nil }
            return AVPlayerItem(url: url)
        }
        store?.send(.updateTotalChaptersCount(playerItems.count))
        
        player = AVQueuePlayer(items: playerItems)
        addPeriodicTimeObserver()
    }
    
    func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self, let playerItem = self.playerItem else { return }
            let duration = playerItem.duration.seconds
            let timeElapsed = time.seconds
            let sliderValue = timeElapsed / duration
            self.updatePosition(timeElapsed)
            self.updateSliderValue(sliderValue)
        }
    }
    
    func updatePosition(_ position: Double) {
        DispatchQueue.main.async {
            self.store?.send(.updatePosition(position))
        }
    }
    
    func updateSliderValue(_ value: Double) {
        DispatchQueue.main.async {
            self.store?.send(.updateSliderValue(value))
        }
    }
    
    func seek(to position: Double) {
        let time = CMTime(seconds: position, preferredTimescale: 600)
        player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            if self?.player?.rate == 0 {
                self?.player?.play()
            }
        }
    }
    
    deinit {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
        }
    }
}


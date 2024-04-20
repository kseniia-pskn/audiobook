//
//  BookPlayerView.swift
//  AudioBook
//
//  Created by Kseniia Piskun on 18.04.2024.
//
import SwiftUI
import ComposableArchitecture

struct BookPlayerView: View {
    let store: Store<BookSummaryState, BookSummaryAction>
    @ObservedObject private var viewStore: ViewStore<BookSummaryState, BookSummaryAction>
    init(store: Store<BookSummaryState, BookSummaryAction>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 20.0) {
            Spacer()
            
            VStack(spacing: 40.0){
                Image("book_cover")
                    .resizable()
                    .frame(width: 250, height: 350)
                    .cornerRadius(12)
                
                VStack(spacing: 12.0){
                    Text("KEY POINT \(viewStore.currentChapter) OF \(viewStore.totalChapters)")
                        .font(.system(size: 18, weight: .medium, design: .default))
                        .foregroundColor(.init(hex: "#999592"))
                        .padding(.bottom)
                    
                    Text("When the heart speaks, the mind finds it indecent to object.")
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .padding(.horizontal, 24.0)
                }
            }
            
            HStack(spacing: 10.0) {
                Text(viewStore.playbackPositionString)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(.init(hex: "#999592"))
                Slider(
                    value: viewStore.binding(
                        get: \.sliderValue,
                        send: BookSummaryAction.sliderValueChanged
                    ), in: 0...1,
                    onEditingChanged: sliderEditingChanged
                )
                Text(viewStore.totalDurationString)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(.init(hex: "#999592"))
            }
            .padding(.horizontal)
            
            VStack(spacing: 60.0){
                Menu {
                    ForEach([0.5, 1.0, 1.5, 1.75, 2.0], id: \.self) { speed in
                        Button("\(speed)x") {
                            viewStore.send(.setPlaybackSpeed(speed))
                        }
                    }
                } label: {
                    Text("Speed x\(String(format: "%g", viewStore.playbackSpeed))")
                        .padding()
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .background(Color.init(hex: "#f2ebe8"))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                VStack(spacing: 40.0){
                    playbackControls()
                    
                    SegmentView()
                }
            }
            
            Spacer()
        }
        .background(Color.init(hex: "fff8f4").edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
        })
        
    }
    
    @ViewBuilder
    func playbackControls() -> some View {
        HStack(alignment: .center,spacing: 36.0 ) {
            Button(action: { viewStore.send(.previousChapter) }) {
                Image(systemName: "backward.end.fill")
                    .resizable()
                    .frame(width: 30.0, height: 30.0)
            }
            .foregroundColor(.black)
            
            Button(action: { viewStore.send(.previousChapter) }) {
                Image(systemName: "gobackward.5")
                    .resizable()
                    .frame(width: 30.0, height: 30.0)
            }
            .foregroundColor(.black)
            
            Button(action: { viewStore.send(.togglePlayPause) }) {
                Image(systemName: viewStore.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: 30.0, height: 30.0)
            }
            .foregroundColor(.black)
            
            Button(action: { viewStore.send(.nextChapter) }) {
                Image(systemName: "goforward.10")
                    .resizable()
                    .frame(width: 30.0, height: 30.0)
            }
            .foregroundColor(.black)
            
            Button(action: { viewStore.send(.nextChapter) }) {
                Image(systemName: "forward.end.fill")
                    .resizable()
                    .frame(width: 30.0, height: 30.0)
            }
            .foregroundColor(.black)
        }
        .frame(height: 35)
        .padding(.horizontal, 50.0)
    }

    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            viewStore.send(.pause)
        } else {
            let currentTime = viewStore.playbackPosition
            viewStore.send(.seekToPosition(currentTime))
            viewStore.send(.play)
        }
    }
}

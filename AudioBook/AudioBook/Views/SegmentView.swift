//
//  SegmentView.swift
//  AudioBook
//
//  Created by Kseniia Piskun on 20.04.2024.
//

import SwiftUI

struct SegmentView: View {
    enum Segment {
        case headphones
        case text
    }
    
    @State private var selectedSegment: Segment = .headphones
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                self.selectedSegment = .headphones
            }) {
                Image(systemName: "headphones")
                    .foregroundColor(selectedSegment == .headphones ? .white : .black)
                    .padding(14)
            }
            .background(selectedSegment == .headphones ? Color.blue : Color.clear)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.blue, lineWidth: selectedSegment == .headphones ? 2 : 0)
            )
            
            Button(action: {
                self.selectedSegment = .text
            }) {
                Image(systemName: "text.alignleft")
                    .foregroundColor(selectedSegment == .text ? .white : .black)
                    .padding(14)
            }
            .background(selectedSegment == .text ? Color.blue : Color.clear)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.blue, lineWidth: selectedSegment == .text ? 2 : 0)
            )
        }
        .frame(width: 110, height: 60)
        .background(Capsule().fill(Color.white))
        .overlay(
            Capsule()
                .stroke(Color.init(hex: "E4E4E4"), lineWidth: 1)
        )
        .padding()
    }
}

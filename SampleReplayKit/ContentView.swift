//
//  ContentView.swift
//  SampleReplayKit
//
//  Created by 永井涼 on 2023/12/29.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @State private var showCountdown = false
    
    var body: some View {
            VStack {
                if viewModel.isRecording {
                    Button(action: {
                        viewModel.onTapRecordingButton()
                    }) {
                        Image(systemName: "stop.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.red)
                    }
                } else if viewModel.showCountdown {
                    VStack {
                        Text("Recording will start in:")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.bottom, 20)
                        
                        Text("\(viewModel.countdownValue)")
                            .font(.system(size: 60, weight: .bold, design: .default))
                            .foregroundColor(.blue)
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .shadow(radius: 10)
                            )
                    }
                } else {
                    Button(action: {
                        viewModel.onTapRecordingButton()
                    }) {
                        Image(systemName: "record.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
        }
}

#Preview {
    ContentView()
}

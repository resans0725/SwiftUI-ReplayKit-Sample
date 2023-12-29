//
//  ContentView.swift
//  SampleReplayKit
//
//  Created by 永井涼 on 2023/12/29.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    
    var body: some View {
        Button(action: {
            viewModel.onTapRecordingButton()
        }) {
            
            Text(viewModel.isRecording ? "録画停止" : "録画開始")
//            Image(systemName:  ? "record.circle.fill" : "record.circle")
//                .font(.largeTitle)
//                .foregroundColor(viewModel.isRecording ? .red : .white)
        }
    }
}

#Preview {
    ContentView()
}

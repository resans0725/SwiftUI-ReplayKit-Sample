//
//  ContentViewModel.swift
//  SampleReplayKit
//
//  Created by 永井涼 on 2023/12/29.
//

import ReplayKit
import Foundation
import Photos

final class ContentViewModel: ObservableObject {
    let recorder = RPScreenRecorder.shared()
        @Published var isRecording = false
        @Published var url: URL?
        @Published var isSaved = false
        @Published var showCountdown = false
        @Published var countdownValue = 3
        
    
    func onTapRecordingButton() {
        if isRecording {
            Task { @MainActor in
                do {
                    self.url = try await stopRecording()
                    print(self.url ?? "")
                    self.isRecording = false
                    
                    if self.url != nil {
                        self.saveVideoToCameraRoll()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            startRecordingWithCountdown()
        }
    }
    
    func startRecordingWithCountdown() {
        showCountdown = true
        countdownValue = 3
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.countdownValue -= 1
            
            if self.countdownValue == 0 {
                timer.invalidate()
                self.showCountdown = false
                
                startRecording { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
                Task { @MainActor in
                    self.isRecording = true
                }
            }
        }
        timer.tolerance = 0.1
    }
    
    private func startRecording(enableMicorphone: Bool = false, completion: @escaping (Error?) -> ()) {
        recorder.isMicrophoneEnabled = false
        recorder.startRecording(handler: completion)
    }
    
    private func stopRecording() async throws -> URL {
        let name = UUID().uuidString + ".mov"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        
        try await recorder.stopRecording(withOutput: url)
        return url
    }
    
    private func cancelRecording() {
        recorder.discardRecording {}
    }
    
    private func saveVideoToCameraRoll() {
        guard let videoURL = self.url else {
               print("No video URL found.")
               return
           }

           PHPhotoLibrary.shared().performChanges {
               PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
           } completionHandler: { success, error in
               if success {
                   print("Video saved to Camera Roll successfully.")
                   self.isSaved = true
               } else {
                   if let error = error {
                       print("Error saving video to Camera Roll: \(error.localizedDescription)")
                   }
               }
           }
    }
}

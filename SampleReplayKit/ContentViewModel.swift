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
    
    func onTapRecordingButton() {
        if isRecording {
            Task { @MainActor in
                do {
                    self.url = try await stopRecording()
                    print(self.url ?? "")
                    self.isRecording = false
                    
                    if let url = self.url {
                        self.saveVideoToCameraRoll()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            startRecording { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
            
            isRecording = true
        }
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
               } else {
                   if let error = error {
                       print("Error saving video to Camera Roll: \(error.localizedDescription)")
                   }
               }
           }
    }
}

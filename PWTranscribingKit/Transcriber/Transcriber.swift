//
//  Transcriber.swift
//  PWTranscribingKit
//
//  Created by jinwoong Kim on 12/6/23.
//

import Foundation
import PWApiWorker

public enum TranscribingError: Error {
    case taskCancelled
}

final public class Transcriber {
    let api: AuthenticatedAudioAPIService
    var task: Task<String, Error>?
    
    public init(api: AuthenticatedAudioAPIService) {
        self.api = api
    }
    
    // TODO: Refactor `try? await task?.value ...` part.
    public func transcribe(with audioUrl: URL) async -> Result<String, TranscribingError> {
        task = Task {
            let result = await api.request(with: audioUrl)
            
            return result
        }
        
        guard let result = try? await task?.value else {
            return .failure(.taskCancelled)
        }
        
        return .success(result)
    }
    
    public func cancel() {
        task?.cancel()
        task = nil
    }
}

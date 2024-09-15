//
//  File.swift
//  
//
//  Created by Yuya Hirayama on 2023/12/24.
//

import Foundation
import Combine

@propertyWrapper
@MainActor public struct Responding<Target: ObservableObject, Responder: PresenterProtocol & ObservableObject> where Responder.ObjectWillChangePublisher == ObservableObjectPublisher {
    public var wrappedValue: Target
    
    public var responder: any PresenterProtocol
    
    public init(wrappedValue: Target, responder: Responder) {
        self.wrappedValue = wrappedValue
        self.responder = responder
        
        wrappedValue.objectWillChange.sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak responder] _ in
                guard let responder else {
                    return
                }
                
                responder.objectWillChange.send()
            }
        )
        .store(in: &responder.cancellables)
    }
}

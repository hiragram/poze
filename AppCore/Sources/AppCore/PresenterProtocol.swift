//
//  PresenterProtocol.swift
//  AppCore
//
//  Created by hiragram on 2022/11/19.
//

import Foundation
import Combine

@MainActor public protocol PresenterProtocol: AnyObject {
    associatedtype Interactor
    associatedtype Router: RouterProtocol

    var interactor: Interactor { get }
    var router: Router { get }
    
    var cancellables: [AnyCancellable] { get set }
    
    func viewDidAppear()
}

public extension PresenterProtocol {
    func viewDidAppear() {}
}

//
//  Command.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import Foundation

public typealias Command = CommandWith<Void>

public struct CommandWith<T> {
    
    private var action: (T) -> Void
    
    public static var nop: CommandWith { return CommandWith { _ in } }
    
    public init(action: @escaping (T) -> Void) {
        self.action = action
    }
    
    public func perform(with value: T) {
        self.action(value)
    }
}

extension CommandWith where T == Void {
    
    public func perform() {
        self.perform(with: ())
    }
}

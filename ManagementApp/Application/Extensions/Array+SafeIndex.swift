//
//  Array+SafeIndex.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
    
    public mutating func replaceItem(at index: Int, with item: Element) {
        
        remove(at: index)
        insert(item, at: index)
    }
}

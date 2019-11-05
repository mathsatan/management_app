//
//  DataSource.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import Foundation

protocol DataSource {
    
    associatedtype Item
    
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> Item
    
    func insert(_ item: Item, at indexPath: IndexPath)
    func remove(at indexPath: IndexPath)
    func replaceItem(at indexPath: IndexPath, with item: Item)
    func append(_ item: Item, at section: Int)
}

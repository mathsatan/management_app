//
//  SectionDataSource.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import Foundation

public struct Section<Item> {
    
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

public class SectionDataSource<Element>: DataSource {

    public typealias Item = Element
    
    public var isEmpty: Bool {
        guard let section = sections.first else {
            return true
        }
        return section.items.isEmpty
    }
    
    public var sections = [Section<Item>]()
    
    public init() {}
    
    public func numberOfSections() -> Int {
        return sections.count
    }
    
    public func numberOfItems(in section: Int) -> Int {
        let currentSection = sections[safeIndex: section]
        return currentSection?.items.count ?? 0
    }
    
    public func item(at indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    public func insert(_ item: Item, at indexPath: IndexPath) {
        var section = sections[indexPath.section]
        section.items.insert(item, at: indexPath.item)
        replaceSection(at: indexPath.section, with: section)
    }
    
    public func remove(at indexPath: IndexPath) {
        var section = sections[indexPath.section]
        section.items.remove(at: indexPath.item)
        replaceSection(at: indexPath.section, with: section)
    }
    
    public func replaceItem(at indexPath: IndexPath, with item: Item) {
        var section = sections[indexPath.section]
        section.items.remove(at: indexPath.item)
        section.items.insert(item, at: indexPath.item)
        replaceSection(at: indexPath.section, with: section)
    }
    
    public func append(_ item: Item, at section: Int) {
        var currentSection = sections[section]
        currentSection.items.append(item)
        replaceSection(at: section, with: currentSection)
    }
    
    public func section(where predicate: (Section<Item>) -> Bool) -> Int? {
        return sections.firstIndex(where: predicate)
    }
    
    public func replaceSection(at index: Int, with section: Section<Item>) {
        
        sections.remove(at: index)
        sections.insert(section, at: index)
    }
    
    public func insertSection(_ section: Section<Item>, at index: Int) {
        sections.insert(section, at: index)
    }
    
    public func removeAll() {
        sections.removeAll()
    }
}

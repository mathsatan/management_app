//
//  Gallery.Interactor.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import Foundation

protocol GalleryInteracting: AnyObject {}

protocol GalleryInteractorOutput: AnyObject {}

extension Gallery {

    final class Interactor {

        // MARK: - Public properties

        weak var output: GalleryInteractorOutput!
    }
}

// MARK: - Business logic

extension Gallery.Interactor: GalleryInteracting {}

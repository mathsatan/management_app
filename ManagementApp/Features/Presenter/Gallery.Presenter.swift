//
//  Gallery.Presenter.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol GalleryPresenting: AnyObject {}

extension Gallery {

    final class Presenter {

        // MARK: - Public properties

        weak var view: GalleryView!
        var router: GalleryRouting!
        var interactor: GalleryInteracting!
    }
}

// MARK: - Presentation logic

extension Gallery.Presenter: GalleryPresenting {}

// MARK: - GalleryInteractorOutput

extension Gallery.Presenter: GalleryInteractorOutput {}

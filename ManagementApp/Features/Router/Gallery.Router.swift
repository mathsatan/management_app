//
//  Gallery.Router.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol GalleryRouting {}

extension Gallery {

    final class Router {

        // MARK: - Public properties

        weak var viewController: GalleryViewController!
        
        static func initialViewController() -> GalleryViewController {
            return R.storyboard.gallery.galleryViewController()!
        }
    }
}

// MARK: - Navigation

extension Gallery.Router: GalleryRouting {}

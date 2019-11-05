//
//  GalleryViewController.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright (c) 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

final class GalleryViewController: BaseViewController {

    // MARK: - Public properties

    var presenter: GalleryPresenting!

    // MARK: - Object lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        Gallery.Module().configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = R.string.tabBar.galleryItemTitle()
    }
}

// MARK: - View logic

extension GalleryViewController: GalleryView {}

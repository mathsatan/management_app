//
//  DropdownNotification.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 05.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

final class DropdownNotification: UIView {
    
    // MARK: - Constants
    private struct Constants {
        let animationDuration: TimeInterval = 0.25
    }
        
    // MARK: - IBOutlets
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var messageImageView: UIImageView!
    
    // MARK: - Private Properties
    
    private static var currentDropdown: DropdownNotification?
    private var message: String!
    private weak var containerView: UIView?
    private var tapGesture: UITapGestureRecognizer?
    
    private var height: CGFloat = 54 {
        didSet {
            frame = CGRect(x: 0.0, y: -height, width: frame.width, height: height)
        }
    }
    private var style: DropdownNotificationStyle?
    
    private var state: DropdownState = .hidden {
        didSet {
            if state == .hidden && DropdownNotification.currentDropdown == self {
                DropdownNotification.currentDropdown = nil
            }
        }
    }
    
    // MARK: - LifeCycle
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(DropdownNotification.handleTap(_:)))
        tapGesture?.cancelsTouchesInView = true
        addGestureRecognizer(tapGesture!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let containerView = containerView {
            frame = CGRect(x: frame.minX, y: frame.minY, width: containerView.bounds.width, height: frame.height)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func handleTap(_ tapGesture: UITapGestureRecognizer) {
        hide(true)
    }
}

// MARK: - Public Methods

extension DropdownNotification {
    
    static func show(with message: String!,
                     animated: Bool = true,
                     height: CGFloat? = nil,
                     inView view: UIView? = nil,
                     style: DropdownNotificationStyle,
                     hideAfter: TimeInterval = 3.0) {
        
        let dropdownHeight: CGFloat
        
        if let height = height {
            dropdownHeight = height
        } else {
            dropdownHeight = UIApplication.shared.statusBarFrame.height + 54.0
        }
        
        currentDropdown?.hide(animated)
        
        var viewToShowIn = view
        
        if viewToShowIn == nil {
            viewToShowIn = UIApplication.shared.keyWindow
        }
        
        if let view = viewToShowIn {
            
            let showAnimated = currentDropdown == nil ? animated : false
            
            currentDropdown = R.nib.dropdownNotification.firstView(owner: nil, options: nil)
            currentDropdown?.style = style
            currentDropdown?.height = dropdownHeight
            currentDropdown?.message = message
            currentDropdown?.show(showAnimated, inView: view, hideAfter: hideAfter, shouldHideAnimated: animated)
        }
    }
    
    func show(_ animated: Bool = true, inView view: UIView!, hideAfter: TimeInterval = 3.0, shouldHideAnimated hideAnimated: Bool = true) {
        containerView = view
        alpha = 0.0
        
        if superview != containerView {
            containerView?.addSubview(self)
        }
        
        backgroundColor = style?.color ?? .white
        messageImageView.image = style?.image ?? nil
        messageImageView.isHidden = style?.image == nil
        
        messageLabel.text = self.message
        
        let animationDuration = animated ? Constants().animationDuration : 0.0
        
        state = .goingToShow
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIView.AnimationOptions(), animations: {
            self.alpha = 1.0
            self.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.height)
        },
                       completion: { _ in
                        self.state = .shown
        })
        
        if hideAfter > 0.0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(hideAfter) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
                self.hide(hideAnimated)
            }
        }
    }
    
    func hide(_ animated: Bool = true) {
        
        let animationDuration = animated ? Constants().animationDuration : 0.0
        
        self.state = .goingToHide
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.frame = CGRect(x: 0.0, y: -self.height, width: self.frame.width, height: self.height)
            self.alpha = 0.0
        }, completion: { _ in
            self.state = .hidden
            self.removeFromSuperview()
        })
    }
}

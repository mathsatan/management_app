//
//  UIView+AddSubviewWithDefaultConstraints.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    public func addSubviewWithDefaultConstraints(_ subview: UIView, useSafeAreaLayoutGuide: Bool = false) -> UIView {
        
        self.addSubview(subview)

        if useSafeAreaLayoutGuide {
            subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
            subview.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
            subview.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            addTopConstraint(0.0, forSubView: subview)
            addBottomConstraint(0.0, forSubView: subview)
            addLeadingConstraint(0.0, forSubView: subview)
            addTrailingConstraint(0.0, forSubView: subview)
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        
        return self
    }
    
    @discardableResult
    public func addTopConstraint(_ constant: CGFloat, forSubView subView: UIView) -> NSLayoutConstraint {
        
        let topConstraint = NSLayoutConstraint(item: subView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: constant)
        self.addConstraint(topConstraint)
        
        topConstraint.isActive = true
        
        return topConstraint
    }
    
    @discardableResult
    public func addBottomConstraint(_ constant: CGFloat, forSubView subView: UIView) -> NSLayoutConstraint {
        
        let bottomConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: subView,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: constant)
        self.addConstraint(bottomConstraint)
        
        bottomConstraint.isActive = true
        
        return bottomConstraint
    }
    
    @discardableResult
    public func addLeadingConstraint(_ constant: CGFloat, forSubView subView: UIView) -> NSLayoutConstraint {
        
        let leadingConstraint = NSLayoutConstraint(item: subView,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .leading,
                                                   multiplier: 1.0,
                                                   constant: constant)
        self.addConstraint(leadingConstraint)
        
        leadingConstraint.isActive = true
        
        return leadingConstraint
    }
    
    @discardableResult
    public func addTrailingConstraint(_ constant: CGFloat, forSubView subView: UIView) -> NSLayoutConstraint {
        
        let trailingConstraint = NSLayoutConstraint(item: subView,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .trailing,
                                                    multiplier: 1.0,
                                                    constant: constant)
        self.addConstraint(trailingConstraint)
        
        trailingConstraint.isActive = true
        
        return trailingConstraint
    }
    
    @discardableResult
    public func addHeightConstraint(_ constant: CGFloat) -> NSLayoutConstraint {
        
        let heightConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .height,
                                                  multiplier: 1.0,
                                                  constant: constant)
        self.addConstraint(heightConstraint)
        
        heightConstraint.isActive = true
        
        return heightConstraint
    }
    
    @discardableResult
    public func addWidthConstraint(_ constant: CGFloat) -> NSLayoutConstraint {
        
        let widthConstraint = NSLayoutConstraint(item: self,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .width,
                                                 multiplier: 1.0,
                                                 constant: constant)
        self.addConstraint(widthConstraint)
        
        widthConstraint.isActive = true
        
        return widthConstraint
    }
    
    @discardableResult
    public func addCenterXConstraint(_ constant: CGFloat, to toView: UIView) -> NSLayoutConstraint {
        
        let centerXConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: toView,
                                                   attribute: .centerX,
                                                   multiplier: 1.0,
                                                   constant: constant)
        self.addConstraint(centerXConstraint)
        
        centerXConstraint.isActive = true
        
        return centerXConstraint
        
    }
    
    @discardableResult
    public func addCenterYConstraint(_ constant: CGFloat, to toView: UIView) -> NSLayoutConstraint {
        
        let centerYConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: toView,
                                                   attribute: .centerY,
                                                   multiplier: 1.0,
                                                   constant: constant)
        self.addConstraint(centerYConstraint)
        
        centerYConstraint.isActive = true
        
        return centerYConstraint
    }
    
    @discardableResult
    public func addAspectRatioConstraint(_ multiplier: CGFloat) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let aspectRatioConstraint = NSLayoutConstraint(item: self,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .width,
                                                       multiplier: multiplier,
                                                       constant: 0)
        
        self.addConstraint(aspectRatioConstraint)
        
        return aspectRatioConstraint
    }
}

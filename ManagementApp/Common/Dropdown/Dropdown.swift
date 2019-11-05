//
//  Dropdown.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 05.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import UIKit

protocol DropdownNotificationStyle {
    var color: UIColor { get }
    var image: UIImage? { get }
}

struct Dropdown {
    
    public enum Style: DropdownNotificationStyle {
        case error
        case disconnected
        case success
        
        var color: UIColor {
            switch self {
            case .error:
                return .red
            case .disconnected:
                return R.color.grey()!
            case .success:
                return R.color.primary()!
            }
        }
        
        var image: UIImage? {
            switch self {
            case .error:
                return nil
            case .disconnected:
                return nil
            case .success:
                return nil
            }
        }
    }

    func showSuccess(with message: String) {
        
        DropdownNotification.show(with: message, animated: true, style: Style.success, hideAfter: 3.0)
    }
    
    func showError(with message: String) {
        
        DropdownNotification.show(with: message, animated: true, style: Style.error, hideAfter: 3.0)
    }
    
    func showDisconnectedState() {
        
        DropdownNotification.show(with: R.string.common.errorNoInternetConnection(),
                                  animated: true,
                                  style: Style.disconnected,
                                  hideAfter: 5.0)
    }
}

//
//  UserDefaultsAppStateService.swift
//  qrcode-uikit
//
//  Created by dima on 22.04.2025.
//

import Foundation

final class AppStateServiceImpl: AppStateService {
    private let key = "hasCompletedOnboarding"
    
    var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: key) }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

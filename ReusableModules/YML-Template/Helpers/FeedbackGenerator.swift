//
//  FeedbackGenerator.swift
//  TGIF
//
//  Created by Y Media Labs on 04/02/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import UIKit

struct FeedbackGenerator {
    
    enum FeedbackType {
        case impactLight
        case impactMedium
        case impactHeavy
        case notificationSuccess
        case notificationWarning
        case notificationError
        case selection
    }
            
    static func generateFeedback(_ type: FeedbackGenerator.FeedbackType) {
        guard #available(iOS 10.0, *) else { return }
        
        switch type {
        case .impactLight:
            generateImapactFeedback(style: .light)
        case .impactMedium:
            generateImapactFeedback(style: .medium)
        case .impactHeavy:
            generateImapactFeedback(style: .heavy)
        case .notificationSuccess:
            generateNotificationFeedback(type: .success)
        case .notificationWarning:
            generateNotificationFeedback(type: .warning)
        case .notificationError:
            generateNotificationFeedback(type: .error)
        case .selection:
            generateSelectionFeedback()
        }
    }
        
    static private func generateImapactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }
    
    static private func generateNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(type)
    }
    
    static private func generateSelectionFeedback() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.prepare()
        selectionFeedback.selectionChanged()
    }
    
}

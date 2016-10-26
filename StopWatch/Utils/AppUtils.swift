//
//  AppUtils.swift
//  StopWatch
//
//  Created by Mutee ur Rehman on 10/25/16.
//  Copyright © 2016 Mutee ur Rehman. All rights reserved.
//

import Foundation
import UIKit

class AppUtils {
    class func removeAllLocalNotifications () {
        if UIApplication.shared.scheduledLocalNotifications != nil {
            for notification in UIApplication.shared.scheduledLocalNotifications! {
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }

    }
    class func scheduleLocalNotification(_ fireDate: Date, alertBody: String, alertAction: String, soundName: String, userInfo: [String: AnyObject] ) {
        let notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.alertBody = alertBody
        notification.alertAction = alertAction
        notification.soundName = soundName
        notification.userInfo = userInfo
        UIApplication.shared.scheduleLocalNotification(notification)
    }
}

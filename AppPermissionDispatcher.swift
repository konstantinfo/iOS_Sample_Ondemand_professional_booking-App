//
//  AppPermissionDispatcher.swift
//

import UIKit
import CoreLocation

let kLocationPermissionDenied           : String =  "To re-enable, please go to Settings and turn on Location Service for "
let kNotificatinPermionDenied   : String = "Please go to Settings and turn on Notification Service for "
let kContactBookPermissionDenied    : String = "Please go to Settings and turn on Contacts Service for "
let kCalendarPermissionDenied    : String = "Please go to Settings and turn on Calendar Service for "
let kPermissionDeniedTitle      : String = "App Permission Denied"
let kMircorPhonePermissionDenied    : String = "Please go to Settings and turn on Mircophone Service for "

class AppPermissionDispatcher: NSObject
{

    static let shared : AppPermissionDispatcher = AppPermissionDispatcher()
    
    @objc func appPermisionStatus()
    {
        
        if CLLocationManager.authorizationStatus() == .denied
        {
            self.showPermissionAlert(message: kLocationPermissionDenied)
            return
            
        }
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .denied
            {
                self.showPermissionAlert(message: kNotificatinPermionDenied)
                return
            }
        }
        // Device Token and Lat & Long API
    }

    func showPermissionAlert(message:String)
    {
        DispatchQueue.main.async {
            GFunction.shared.showAlert(kPermissionDeniedTitle,actionOkTitle: "Settings", actionCancelTitle: "Cancel", message: message + kAppName) { (completed) in
                if completed
                {
                    UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
                }
            }
        }        
    }
    
    func contactBookPermissionStatus()
    {
        
    }
    
    func mircophonePermission(complation:@escaping ((AVAudioSession.RecordPermission) -> Void))
    {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            complation(.granted)
        case AVAudioSession.RecordPermission.denied:
            self.showPermissionAlert(message: kMircorPhonePermissionDenied)
            complation(.denied)
        case AVAudioSession.RecordPermission.undetermined:
            complation(.undetermined)
        default:
            break
        }
    }
    
}

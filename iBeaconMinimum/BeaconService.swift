
import CoreLocation
import Foundation
import CocoaLumberjack
import UserNotifications

protocol MonitoringViewDelegate {
    func setStatusLabel(_ label: String)
}

class BeaconService: NSObject, CLLocationManagerDelegate {
    
    let regionstates = ["unknown", "inside", "outside"]
    
    static let sharedInstance = BeaconService()
    let locationManager = CLLocationManager()

    var currentState = CLRegionState.unknown {
        didSet {
            monitoringViewDelegate?.setStatusLabel("CLRegionState: \(regionstates[currentState.rawValue]) (\(currentState.rawValue))")
        }
    }

    var monitoringViewDelegate: MonitoringViewDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func startRegionMonitoring(_ name: String, uuid: String, major: String, minor: String) {
        stopRegionMonitoring()
        let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(uuidString: uuid) as! UUID,
                                          major: CLBeaconMajorValue(major)!,
                                          minor: CLBeaconMinorValue(minor)!,
                                          identifier: "tour-test-region-\(name)")
        beaconRegion.notifyEntryStateOnDisplay = true
        DDLogInfo("starting region monitoring for \(beaconRegion.identifier) UUID: \(beaconRegion.proximityUUID) major: \(beaconRegion.major) minor: \(beaconRegion.minor)")
        locationManager.startMonitoring(for: beaconRegion)
        currentState = CLRegionState.unknown
    }
    
    func stopRegionMonitoring() {
        for region in locationManager.monitoredRegions {
            if let region = region as? CLBeaconRegion {
                DDLogInfo("stopping region monitoring for \(region.identifier) UUID: \(region.proximityUUID) major: \(region.major) minor: \(region.minor)")
            }
            locationManager.stopMonitoring(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        DDLogInfo("didDetermineState \(state.rawValue) for \(region.identifier)")
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        let dateTimeString = formatter.string(from: Date())
        let content = UNMutableNotificationContent()
        if state == CLRegionState.inside {
            if currentState != CLRegionState.inside {
                content.title = "Inside Beacon Region \(dateTimeString)"
                content.body = "Region: \(region.identifier)"
                content.sound = UNNotificationSound.default()
                let request = UNNotificationRequest(identifier: "Inside \(UUID().uuidString)", content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request)
            }
        } else if state == CLRegionState.outside {
            if currentState != CLRegionState.outside {
                let content = UNMutableNotificationContent()
                content.title = "Outside Beacon Region \(dateTimeString)"
                content.body = "Region: \(region.identifier)"
                content.sound = UNNotificationSound.default()
                let request = UNNotificationRequest(identifier: "Outside \(UUID().uuidString)", content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request)
            }
        } else {
        }
        currentState = state
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        DDLogInfo("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DDLogInfo("Location manager failed: \(error.localizedDescription)")
    }
    
}

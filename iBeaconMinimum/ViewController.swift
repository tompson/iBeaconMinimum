
import CocoaLumberjack
import UIKit

class ViewController: UIViewController, MonitoringViewDelegate {
    
    let selectedBeaconSegmentKey = "selectedBeaconSegment"
    let recordingStatusKey = "recordingStatus"
    
    let regions = [
        ["Tom", "a3e246e3-84b7-42b8-b9ee-a612555d8230","1509","10711"],
        ["Mario", "a3e246e3-84b7-42b8-b9ee-a612555d8230","1504","15150"],
        ["Brandy", "a3e246e3-84b7-42b8-b9ee-a612555d8230","57075","7399"] ]

    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var statuslabel: UILabel!
    @IBOutlet weak var beaconSegment: UISegmentedControl!
    @IBOutlet weak var recordingSwitch: UISwitch!
    
    var regionConfig = [String]() {
        didSet {
            self.setBeaconLabels(regionConfig[1], major: regionConfig[2], minor: regionConfig[3])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BeaconService.sharedInstance.monitoringViewDelegate = self
        let defaults = UserDefaults.standard
        recordingSwitch.setOn(defaults.bool(forKey: recordingStatusKey) , animated: false)
        beaconSegment.selectedSegmentIndex = defaults.integer(forKey: selectedBeaconSegmentKey)
        regionConfig = regions[beaconSegment.selectedSegmentIndex]
        if recordingSwitch.isOn {
            BeaconService.sharedInstance.startRegionMonitoring(regionConfig[0], uuid: regionConfig[1], major: regionConfig[2], minor: regionConfig[3])
        } else {
            BeaconService.sharedInstance.stopRegionMonitoring()
        }
    }

    @IBAction func changedBeaconSegment(_ sender: UISegmentedControl) {
        let defaults = UserDefaults.standard
        defaults.set(sender.selectedSegmentIndex, forKey: selectedBeaconSegmentKey)
        regionConfig = regions[sender.selectedSegmentIndex]
        if recordingSwitch.isOn {
            BeaconService.sharedInstance.startRegionMonitoring(regionConfig[0], uuid: regionConfig[1], major: regionConfig[2], minor: regionConfig[3])
        } else {
            BeaconService.sharedInstance.stopRegionMonitoring()
        }
    }
    
    @IBAction func recordingSwitchChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        defaults.set(sender.isOn, forKey: recordingStatusKey)
        if recordingSwitch.isOn {
            BeaconService.sharedInstance.startRegionMonitoring(regionConfig[0], uuid: regionConfig[1], major: regionConfig[2], minor: regionConfig[3])
        } else {
            BeaconService.sharedInstance.stopRegionMonitoring()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setStatusLabel(_ label: String) {
        statuslabel.text = label
    }
    
    func setBeaconLabels(_ uuid: String, major: String, minor: String) {
        uuidLabel.text = uuid
        majorLabel.text = major
        minorLabel.text = minor
    }
    
}


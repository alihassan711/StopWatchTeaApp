//
//  ViewController.swift
//  StopWatch
//
//  Created by Mutee ur Rehman on 10/24/16.
//  Copyright © 2016 Mutee ur Rehman. All rights reserved.
//

import UIKit
import AVFoundation

//MARK: VIEW COTROLLER
class ViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var stopWatchRemainingTimeLabel: UILabel!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var rooibosButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var oolongButton: UIButton!
    @IBOutlet weak var puErhButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startStopLabel: UILabel!

    //MARK: Properties
    var remainingStopWatchTimeInSeconds : Int = 0
    var timer: Timer!
    let goldenColor = UIColor.init(red: 141.0/255.0, green: 130.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    let grayColor = UIColor.init(red: 48.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    let buttonsBorderWidth: Float = 2.0
    var selectedButton: UIButton!

    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        //Remove from notifications if already added as an observer.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        //Add as an observer
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.appGoingToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    override func viewDidLayoutSubviews() {
        makeAllButtonsRound()
        setBordersOfAllButtons()
    }
}

//MARK: TIMER HANDLING
extension ViewController {
    func setTimer() {
        endTimer()
        startStopLabel.text = AppStringConstants.StopText
        setButtonsText()
        setBordersOfAllButtons()
        selectedButton.setTitleColor(grayColor, for: UIControlState.normal)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.timerUpdated), userInfo: nil, repeats: true)
    }
    func endTimer() {
        if selectedButton == nil {
            setBordersOfAllButtons()
            setButtonsText()
            startStopLabel.text = AppStringConstants.StartStopText
        }
        else {
            startStopLabel.text = AppStringConstants.StartText
        }
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    func timerUpdated() {
        remainingStopWatchTimeInSeconds -= 1
        if remainingStopWatchTimeInSeconds <= 0 {
            remainingStopWatchTimeInSeconds = 0
            
            selectedButton = nil
           
            //invalidate timer
            endTimer()
            //set label
            setstopWatchRemainingTimeLabelText()
            //beep
            let systemSoundID: SystemSoundID = 1016
            AudioServicesPlaySystemSound(systemSoundID)
        }
        else {
            setstopWatchRemainingTimeLabelText()
        }
    }
    func setstopWatchRemainingTimeLabelText() {
        let minutes: Int = remainingStopWatchTimeInSeconds/60
        let seconds: Int = remainingStopWatchTimeInSeconds%60
        stopWatchRemainingTimeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}

//MARK: HANDLE APP STATUS NOTIFICATIONS
extension ViewController {
    func appGoingToBackground() {
        
        endTimer()
        if remainingStopWatchTimeInSeconds > 0 {
            UserDefaults.standard.set(Date(timeIntervalSinceNow: TimeInterval(remainingStopWatchTimeInSeconds)), forKey: "timerEndingDate")
            UserDefaults.standard.synchronize()
            scheduleNotification()
        }
    }
    func appDidBecomeActive() {
        if UserDefaults.standard.object(forKey: "timerEndingDate") != nil { //If there is some ending date
            let endingDate = UserDefaults.standard.object(forKey: "timerEndingDate") as! Date
            if endingDate.compare(Date()) == .orderedDescending {     // If ending date is greater than current date
                let differenceInSeconds = endingDate.timeIntervalSince(Date()) //Difference Between ending date and current date In Seconds
                remainingStopWatchTimeInSeconds = Int(differenceInSeconds) //This difference is the remaining time of stop watch
                setTimer()
            }
            else {  // If ending date is smaller than the current date, it means endign date is past now and stop watch has no ramaining Time.
                remainingStopWatchTimeInSeconds = 0
            }
        }
        else { //No ending date means stop watch was not running when app went to background or terminated last time or app launches for the first time.
            remainingStopWatchTimeInSeconds = 0
        }
        setstopWatchRemainingTimeLabelText()
        UserDefaults.standard.removeObject(forKey: "timerEndingDate")
        UserDefaults.standard.synchronize()
    }

}

//MARK: HANDLES LOCAL NOTIFICATIONS PART
extension ViewController {
    func scheduleNotification() {
        AppUtils.removeAllLocalNotifications()
      
        let notificationScheduleDate = Date(timeIntervalSinceNow: TimeInterval(remainingStopWatchTimeInSeconds) )
        AppUtils.scheduleLocalNotification(notificationScheduleDate, alertBody: "Time Up", alertAction: "be awesome!", soundName: "beep21.mp3", userInfo: ["CustomField1": "w00t" as AnyObject])
    }

}

//MARK: UI SETTINGS
extension ViewController {
    func makeAllButtonsRound() {
        blackButton.makeRound()
        rooibosButton.makeRound()
        greenButton.makeRound()
        oolongButton.makeRound()
        puErhButton.makeRound()
        whiteButton.makeRound()
        stopButton.makeRound()
        startStopLabel.makeRound()
    }
    func setBordersOfAllButtons() {
        blackButton.setBorder(width: buttonsBorderWidth, colorIfNotEuqalToSelected: goldenColor, colorIfEqualToSelected: grayColor, selectedView: selectedButton)
        rooibosButton.setBorder(width: buttonsBorderWidth, colorIfNotEuqalToSelected: goldenColor, colorIfEqualToSelected: grayColor, selectedView: selectedButton)
        greenButton.setBorder(width: buttonsBorderWidth, colorIfNotEuqalToSelected: goldenColor, colorIfEqualToSelected: grayColor, selectedView: selectedButton)
        oolongButton.setBorder(width: buttonsBorderWidth, colorIfNotEuqalToSelected: goldenColor, colorIfEqualToSelected: grayColor, selectedView: selectedButton)
        puErhButton.setBorder(width: buttonsBorderWidth, colorIfNotEuqalToSelected: goldenColor, colorIfEqualToSelected: grayColor, selectedView: selectedButton)
        whiteButton.setBorder(width: buttonsBorderWidth, colorIfNotEuqalToSelected: goldenColor, colorIfEqualToSelected: grayColor, selectedView: selectedButton)
        stopButton.setBorder(width: buttonsBorderWidth, color: grayColor)
    }
    func setButtonsText() {
        blackButton.setTitleColor(goldenColor, for: UIControlState.normal)
        rooibosButton.setTitleColor(goldenColor, for: UIControlState.normal)
        greenButton.setTitleColor(goldenColor, for: UIControlState.normal)
        oolongButton.setTitleColor(goldenColor, for: UIControlState.normal)
        puErhButton.setTitleColor(goldenColor, for: UIControlState.normal)
        whiteButton.setTitleColor(goldenColor, for: UIControlState.normal)
        stopButton.setTitleColor(grayColor, for: UIControlState.normal)
    }
}

//MARK: IBACTIONS
extension ViewController {
    @IBAction func blackButtonClicked(_ sender: UIButton) {
        selectedButton = blackButton
        remainingStopWatchTimeInSeconds =  60 * 5
        setTimer()
    }
    @IBAction func rooibosButtonClicked(_ sender: UIButton) {
        selectedButton = rooibosButton
        remainingStopWatchTimeInSeconds =  60 * 5
        setTimer()
    }
    @IBAction func greenButtonClicked(_ sender: UIButton) {
        selectedButton = greenButton
        remainingStopWatchTimeInSeconds =  60 * 3
        setTimer()
    }
    @IBAction func oolongButtonClicked(_ sender: UIButton) {
        selectedButton = oolongButton
        remainingStopWatchTimeInSeconds =  60 * 3
        setTimer()
    }
    @IBAction func puErhButtonClicked(_ sender: UIButton) {
        selectedButton = puErhButton
        remainingStopWatchTimeInSeconds =  60 * 5
        setTimer()
    }
    @IBAction func whiteButtonClicked(_ sender: UIButton) {
        selectedButton = whiteButton
        remainingStopWatchTimeInSeconds =  60 * 4
        setTimer()
    }
    @IBAction func stopButtonClicked(_ sender: UIButton) {
        if timer != nil && timer.isValid {
            endTimer()
            setstopWatchRemainingTimeLabelText()
        }
        else if selectedButton != nil {
            setTimer()
        }
    }
}




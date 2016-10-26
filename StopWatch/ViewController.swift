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

    //MARK: Properties
    var remainingStopWatchTimeInSeconds : Int = 0
    var timer: NSTimer!
    let buttonsBorderColor = UIColor.init(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1.0)
    let buttonsBorderWidth: Float = 2.0
   

    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAllButtonsRound()
        setBordersOfAllButtons()
    }
    override func viewWillAppear(animated: Bool) {
        //Remove from notifications if already added as an observer.
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        //Add as an observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.appGoingToBackground), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.appDidBecomeActive), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

}

//MARK: TIMER HANDLING
extension ViewController {
    func setTimer() {
        endTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.timerUpdated), userInfo: nil, repeats: true)
    }
    func endTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    func timerUpdated() {
        remainingStopWatchTimeInSeconds -= 1
        if remainingStopWatchTimeInSeconds <= 0 {
            remainingStopWatchTimeInSeconds = 0
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
        stopWatchRemainingTimeLabel.text = String(format: "%02d : %02d", minutes, seconds)
    }

}

//MARK: HANDLE APP STATUS NOTIFICATIONS
extension ViewController {
    func appGoingToBackground() {
        
        endTimer()
        if remainingStopWatchTimeInSeconds > 0 {
            NSUserDefaults.standardUserDefaults().setObject(NSDate(timeIntervalSinceNow: NSTimeInterval(remainingStopWatchTimeInSeconds)), forKey: "timerEndingDate")
            NSUserDefaults.standardUserDefaults().synchronize()
            scheduleNotification()
        }
    }
    func appDidBecomeActive() {
        if NSUserDefaults.standardUserDefaults().objectForKey("timerEndingDate") != nil { //If there is some ending date
            let endingDate = NSUserDefaults.standardUserDefaults().objectForKey("timerEndingDate") as! NSDate
            if endingDate.compare(NSDate()) == .OrderedDescending {     // If ending date is greater than current date
                let differenceInSeconds = endingDate.timeIntervalSinceDate(NSDate()) //Difference Between ending date and current date In Seconds
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
        NSUserDefaults.standardUserDefaults().removeObjectForKey("timerEndingDate")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

}

//MARK: HANDLES LOCAL NOTIFICATIONS PART
extension ViewController {
    func scheduleNotification() {
        AppUtils.removeAllLocalNotifications()
      
        let notificationScheduleDate = NSDate(timeIntervalSinceNow: NSTimeInterval(remainingStopWatchTimeInSeconds) )
        AppUtils.scheduleLocalNotification(notificationScheduleDate, alertBody: "Time Up", alertAction: "be awesome!", soundName: "beep21.mp3", userInfo: ["CustomField1": "w00t"])
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
    }
    func setBordersOfAllButtons() {
        blackButton.setBorder(buttonsBorderWidth, color: buttonsBorderColor)
        rooibosButton.setBorder(buttonsBorderWidth, color: buttonsBorderColor)
        greenButton.setBorder(buttonsBorderWidth, color: buttonsBorderColor)
        oolongButton.setBorder(buttonsBorderWidth, color: buttonsBorderColor)
        puErhButton.setBorder(buttonsBorderWidth, color: buttonsBorderColor)
        whiteButton.setBorder(buttonsBorderWidth, color: buttonsBorderColor)
        stopButton.setBorder(buttonsBorderWidth, color: buttonsBorderColor)
    }
}

//MARK: IBACTIONS
extension ViewController {
    @IBAction func blackButtonClicked(sender: UIButton) {
        remainingStopWatchTimeInSeconds =  60 * 5
        setTimer()
    }
    @IBAction func rooibosButtonClicked(sender: UIButton) {
        remainingStopWatchTimeInSeconds =  60 * 5
        setTimer()
    }
    @IBAction func greenButtonClicked(sender: UIButton) {
        remainingStopWatchTimeInSeconds =  60 * 3
        setTimer()
    }
    @IBAction func oolongButtonClicked(sender: UIButton) {
        remainingStopWatchTimeInSeconds =  60 * 3
        setTimer()
    }
    @IBAction func puErhButtonClicked(sender: UIButton) {
        remainingStopWatchTimeInSeconds =  60 * 5
        setTimer()
    }
    @IBAction func whiteButtonClicked(sender: UIButton) {
        remainingStopWatchTimeInSeconds =  60 * 4
        setTimer()
    }
    @IBAction func stopButtonClicked(sender: UIButton) {
        remainingStopWatchTimeInSeconds = 0
        endTimer()
        setstopWatchRemainingTimeLabelText()
    }
}




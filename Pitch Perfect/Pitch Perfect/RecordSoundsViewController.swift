//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by José Corcuera on 3/4/15.
//  Copyright (c) 2015 Jose Corcuera. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        // Setup initial states of UI Elements
        prepareUIForRecording()
    }

    @IBAction func recordAudio(sender: UIButton) {
        // Update UI Elements
        recordingStatusLabel.text = "Recording..."
        recordButton.enabled = false
        stopButton.hidden = false
        pauseButton.hidden = false
        resumeButton.hidden = true

        
        // Format and set path for audio file.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Start recording
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        
        audioRecorder.record()
    }
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        // Update UI Elements
        recordingStatusLabel.hidden = true
        recordButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        
        // Stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
    @IBAction func pauseRecordingAudio(sender: UIButton) {
        // Update UI Elements
        recordingStatusLabel.text = "Press Play to resume or Stop to Finish"
        pauseButton.hidden = true
        resumeButton.hidden = false
        
        // Pause recording
        audioRecorder.pause()
    }
    
    @IBAction func resumeRecordingAudio(sender: UIButton) {
        // Update UI Elements
        recordingStatusLabel.text = "Recording..."
        pauseButton.hidden = false
        resumeButton.hidden = true
        
        // Resume recording
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent, filePathUrl: recorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            prepareUIForRecording()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func prepareUIForRecording(){
        // Initial UI setup
        recordingStatusLabel.text = "Tap to Record"
        recordingStatusLabel.hidden = false
        recordButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
    }
    
}


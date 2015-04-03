//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by José Corcuera on 3/11/15.
//  Copyright (c) 2015 Jose Corcuera. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize AVAudioPlayer and AVAudioEngine with recorded audio file
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        // Create a delay effect with .8 seconds and 50% of mix.
        var delayEffect = AVAudioUnitDelay()
        delayEffect.delayTime = 0.8
        delayEffect.wetDryMix = 50
        playAudioAndApplyEffect(delayEffect)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        // Create a reverb effect type Cathedral and 50% of mix.
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 50
        playAudioAndApplyEffect(reverbEffect)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAndResetAudio()
    }
    
    func playAudio(rate: Float) {
        stopAndResetAudio()
        
        // Modify audio rate
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioAndApplyEffect(audioEffect: AVAudioNode){
        stopAndResetAudio()
        
        // Function used to play audio with one effect
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(audioEffect)
        
        audioEngine.connect(audioPlayerNode, to: audioEffect, format: nil)
        audioEngine.connect(audioEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){     
        // Add Pitch effect
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        playAudioAndApplyEffect(changePitchEffect)
    }
    
    func stopAndResetAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

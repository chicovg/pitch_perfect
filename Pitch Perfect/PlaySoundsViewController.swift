//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Victor Guthrie on 9/17/15.
//  Copyright © 2015 Victor Guthrie. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioEngine: AVAudioEngine?
    var myAudioFile: AVAudioFile?
    var recordedAudio: RecordedAudio?
    var pitchPlayer: AVAudioPlayerNode?
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioEngine = AVAudioEngine()
        stopButton.enabled = false
        
        do {
            if let recordedAudio = recordedAudio {
                myAudioFile = try AVAudioFile(forReading: recordedAudio.recordedAudioFileURL)
            }
        } catch _ {
            print("unable to open audio file")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playWithHigherPitch(sender: UIButton) {
        playAudioWithTimePitch(1000)
    }
    
    @IBAction func playWithLowerPitch(sender: UIButton) {
        playAudioWithTimePitch(-1000)
        
    }
    
    @IBAction func playAtSlowerRate(sender: UIButton) {
        playAudioWithRate(0.5)
    }
    
    @IBAction func playAtFasterRate(sender: UIButton) {
        playAudioWithRate(2.0)
    }
    
    @IBAction func stopPlayingSounds(sender: UIButton) {
        stopPlayback()
    }
    
    /*
        Helper function to play audio at the specified pitch
    */
    private func playAudioWithTimePitch(pitch: Float) {
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        playAudio(timePitch)
    }
    
    /*
        Helper function to play audio at the specified speed
    */
    private func playAudioWithRate(rate: Float) {
        let varispeed = AVAudioUnitVarispeed()
        varispeed.rate = rate
        playAudio(varispeed)
    }
    
    /*
        Helper function to play audio with the specified effect
    */
    private func playAudio(effect: AVAudioNode) {
        stopPlayback()
        pitchPlayer = AVAudioPlayerNode()
        
        // attach player and effect node to audio engine
        if let audioEngine = audioEngine  {
            audioEngine.attachNode(pitchPlayer!)
            audioEngine.attachNode(effect)
            
            if let myAudioFile = myAudioFile {
                audioEngine.connect(pitchPlayer!, to: effect, format: myAudioFile.processingFormat)
                audioEngine.connect(effect, to: audioEngine.outputNode, format: myAudioFile.processingFormat)
                
                pitchPlayer!.scheduleFile(myAudioFile, atTime: nil, completionHandler: {
                    Void in
                    self.stopButton.enabled = false
                })
            }
            
            // start audio engine and play audio
            do {
                try audioEngine.start()
                pitchPlayer!.play()
                stopButton.enabled = true
            } catch _ {
                print("Could not start audio engine!")
            }
        }
    }
    
    
    /*
        Helper function to stop audio engine
    */
    private func stopPlayback() {
        stopButton.enabled = false
        if let pPlayer = pitchPlayer {
            pPlayer.stop()
        }
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
}

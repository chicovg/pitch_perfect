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
        stopPlayback()
        
        // create audio player node and time pitch effect node
        pitchPlayer = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        
        // attach player and effect node to audio engine
        if let audioEngine = audioEngine  {
            audioEngine.attachNode(pitchPlayer!)
            audioEngine.attachNode(timePitch)
            
            if let myAudioFile = myAudioFile {
                audioEngine.connect(pitchPlayer!, to: timePitch, format: myAudioFile.processingFormat)
                audioEngine.connect(timePitch, to: audioEngine.outputNode, format: myAudioFile.processingFormat)
                
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
        Helper function to play audio at the specified speed
    */
    private func playAudioWithRate(rate: Float) {
        stopPlayback()
        
        // create audio player node and varispeed effect node
        pitchPlayer = AVAudioPlayerNode()
        let varispeed = AVAudioUnitVarispeed()
        varispeed.rate = rate
        
        // attach player and effect node to audio engine
        if let audioEngine = audioEngine  {
            audioEngine.attachNode(pitchPlayer!)
            audioEngine.attachNode(varispeed)
            
            if let myAudioFile = myAudioFile {
                audioEngine.connect(pitchPlayer!, to: varispeed, format: myAudioFile.processingFormat)
                audioEngine.connect(varispeed, to: audioEngine.outputNode, format: myAudioFile.processingFormat)
                
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

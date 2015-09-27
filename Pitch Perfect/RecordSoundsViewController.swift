//
//  RecordSoundsViewController
//  Pitch Perfect
//
//  Created by Victor Guthrie on 9/16/15.
//  Copyright (c) 2015 Victor Guthrie. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var audioRecorder:AVAudioRecorder?
    var recording = false
    var paused = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingLabel.text = "Record!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopRecordingButton.hidden = true
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToPlaySounds" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            playSoundsVC.recordedAudio = sender as? RecordedAudio
        }
    }

    @IBAction func startRecording(sender: UIButton) {
         if(!recording) {
            let audioDir: String = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
            let fileName = "pitch_perfect_recording.wav"
            let audioUrl = NSURL.fileURLWithPathComponents([audioDir, fileName])
            
            // start new audio session & record!
            let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch _ {
                print("Could not open audio session.")
            }
            
            audioRecorder = try? AVAudioRecorder(URL: audioUrl!, settings: ["":""])
            audioRecorder!.meteringEnabled = true
            audioRecorder!.delegate = self
            audioRecorder!.record()
            
            stopRecordingButton.hidden = false
            recording = true
            recordingLabel.text = "Recording!"
            startAnimatingRecordButton()
        } else if (paused) {
            if let audioRecorder = audioRecorder {
                audioRecorder.record()
                recording = true
                paused = false
                recordingLabel.text = "Recording!"
                startAnimatingRecordButton()
            }
        } else {
            if let audioRecorder = audioRecorder {
                audioRecorder.pause()
                paused = true
                recordingLabel.text = "Resume!"
                stopAnimatingRecordButton()
            }
        }
    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        if let audioRecorder = audioRecorder {
            audioRecorder.stop()
            stopRecordingButton.hidden = true
            recording = false
            paused = false
            stopAnimatingRecordButton()
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        // If record was successful, segue to PlaySoundsViewController passing a RecordedAudio object
        if(flag) {
            let recordedAudio = RecordedAudio(withFileAndTitle: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("segueToPlaySounds", sender: recordedAudio)
        } else {
            print("Recording unsuccessful!")
            recordButton.enabled = true
            stopRecordingButton.hidden = true
        }
        recordingLabel.text = "Record!"
        recording = false
    }
    
    // start an animation which make the record button appear to blink
    private func startAnimatingRecordButton(){
        recordButton.alpha = 1.0
        UIView.animateWithDuration(0.75,
            delay: 0,
            options: [UIViewAnimationOptions.CurveEaseInOut, UIViewAnimationOptions.Repeat,
                UIViewAnimationOptions.Autoreverse, UIViewAnimationOptions.AllowUserInteraction],
            animations: {
                Void in
                self.recordButton.alpha = 0.5
            }, completion: nil)
    }
    
    // stop the blinking animation on the record button
    private func stopAnimatingRecordButton(){
        UIView.animateWithDuration(0.12,
            delay: 0,
            options: [UIViewAnimationOptions.CurveEaseInOut, UIViewAnimationOptions.BeginFromCurrentState],
            animations: {
                Void in
                self.recordButton.alpha = 1.0
            }, completion: nil)
    }
}


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
    
    var audioRecorder:AVAudioRecorder!
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
            playSoundsVC.recordedAudio = sender as! RecordedAudio
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
            }
            
            audioRecorder = try? AVAudioRecorder(URL: audioUrl!, settings: ["":""])
            audioRecorder.meteringEnabled = true
            audioRecorder.delegate = self
            audioRecorder.record()
            
            stopRecordingButton.hidden = false
            recording = true
            recordingLabel.text = "Recording!"
        } else if (paused) {
            audioRecorder.record()
            recording = true
            paused = false
            recordingLabel.text = "Recording!"
        } else {
            audioRecorder.pause()
            paused = true
            recordingLabel.text = "Resume!"
        }
    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        stopRecordingButton.hidden = true
        recording = false
        paused = false
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            let recordedAudio = RecordedAudio()
            recordedAudio.recordedAudioFileURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            performSegueWithIdentifier("segueToPlaySounds", sender: recordedAudio)
        } else {
            print("Recording unsuccessful!")
            recordButton.enabled = true
            stopRecordingButton.hidden = true
        }
        recordingLabel.text = "Record!"
        recording = false
    }
}


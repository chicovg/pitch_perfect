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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopRecordingButton.hidden = true
        
    }

    @IBAction func startRecording(sender: UIButton) {
        // get audio dir
        let audioDir: String = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
        let dataFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "ddMMyyyy-HHmmss"
        
        // generate filename based on current datetime
        let fileName = "\(dataFormatter.stringFromDate(NSDate())).wav"
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
    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        if audioRecorder.recording {
            audioRecorder.stop()
        }
        stopRecordingButton.hidden = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        performSegueWithIdentifier("segueToPlaySounds", sender: self)
    }
}


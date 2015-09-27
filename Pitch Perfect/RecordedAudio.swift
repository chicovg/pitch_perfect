//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Victor Guthrie on 9/19/15.
//  Copyright © 2015 Victor Guthrie. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var recordedAudioFileURL: NSURL!
    var title: String!
    
    init(withFileAndTitle file: NSURL, title: String){
        self.recordedAudioFileURL = file
        self.title = title
    }
}

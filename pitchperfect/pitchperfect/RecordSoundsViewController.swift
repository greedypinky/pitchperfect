//
//  RecordSoundsViewController.swift
//  pitchperfect
//
//  Created by Man Wai  Law on 2018-10-13.
//  Copyright © 2018 Rita's company. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    // MARK: Properties
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordButton: UIButton!
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    let RECORDING = "recording in progress";
    let BEFORE_RECORDING = "Press to start record"
    let recordFileName = "myRecordFile.wav"
    
    var isRecording : Bool = false
    
    @IBAction func startRecord(_ sender: Any) {
        changeButtonState(isRecording)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordButton.isEnabled = false
    }
    
    func changeButtonState(_ recording:Bool) {
        if (!recording) {
            recordingLabel.text = RECORDING
            recordButton.isEnabled = false
            stopRecordButton.isEnabled = true
            print("start recoding")
            avAudioRecord(recordFileName: recordFileName)
            
        } else {
            recordingLabel.text = BEFORE_RECORDING
            stopRecordButton.isEnabled = false
            recordButton.isEnabled = true
            
            print("stop recording")
            
            let session = AVAudioSession.sharedInstance()
            try! session.setActive(false)
            audioRecorder.stop()
            

        }
        isRecording.toggle()
    }

    func avAudioRecord(recordFileName:String) {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as String
        let pathArray = [dirPath,  recordFileName]
        let filePathURL = URL(string:pathArray.joined(separator: "/"))
        print(filePathURL!)
        
        // create a recording session and set the category.
        let session = AVAudioSession.sharedInstance()
        // use try! - do not handle the exception
        // Swift version 4.2
//        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        // Swift version 4.0
        try! session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
    
        //  Init the AVAudioRecorder and call the record method to record
        // the call can throw so need to use try
        try! audioRecorder = AVAudioRecorder(url: filePathURL!, settings: [:])
        print("set delegate")
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    
    }
    
    
    // MARK: Method that we need to implement because the class is conformed to the AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        print("delegate method : DidFinishRecording...")
        if (flag) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("some error occurs when recording!")
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "stopRecording") {
            // upcast to PlaySoundViewController
            let destinationVC = segue.destination as! PlaySoundsViewController
            destinationVC.recordedAudioURL = (sender as! URL)
            
        } else {
            print("Invalid segue identifier!")
            
        }
    }
    
}


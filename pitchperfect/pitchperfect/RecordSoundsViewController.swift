//
//  RecordSoundsViewController.swift
//  pitchperfect
//
//  Created by Man Wai  Law on 2018-10-13.
//  Copyright © 2018 Rita's company. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
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
        print("start recoding")
        isRecording = true
        changeButtonState(isRecording)
        avAudioRecord(recordFileName: recordFileName)
    }
    
    @IBAction func stopRecord(_ sender: Any) {
        print("stop recording")
        isRecording = false
        changeButtonState(isRecording)
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
        audioRecorder.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordButton.isEnabled = false
    }
    
    func changeButtonState(_ recording:Bool) {
        recordingLabel.text = recording ? RECORDING : BEFORE_RECORDING
        recordButton.isEnabled = !recording
        stopRecordButton.isEnabled = recording
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
    
    // MARK: Navigation - pass the recordedAudioURL to the destination view controller
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


// MARK: - extension for AVAudioRecorderDelegate delegate
extension RecordSoundsViewController : AVAudioRecorderDelegate {
    
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

            print("delegate method : DidFinishRecording...")
            if (flag) {
                performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            } else {
                print("some error occurs when recording!")
            }
        }
}

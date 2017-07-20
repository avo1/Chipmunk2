//
//  RecordSoundsViewController.swift
//  Chipmunk
//
//  Created by Dave Vo on 10/13/15.
//  Copyright © 2015 avo. All rights reserved.
//

import UIKit
import AVFoundation



class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        stopButton.isHidden = true
    }
    
    // MARK: - Record audio

    @IBAction func recordAudio(_ sender: UIButton) {
        print("recordbutton clicked")
        // TODO: add label "recording in progress"
        infoLabel.text = "Recording"
        stopButton.isHidden = false
        
        // TODO: record user voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
//        let currentDateTime = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "ddMMyyyy-HHmmss"
//        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        
        let filePath = dirPath.appending("/myAudio.wav")
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: URL(string: filePath)!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        print("stopButton clicked")
        //stopButton.hidden = true
        infoLabel.text = "Tap to start record"
        
        audioRecorder.stop()
        // TODO: understand why do we need these 2 lines
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // TODO: saved recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent //this's actually the name of the file
            print("finish recording, saved")
            
            // TODO: move to 2nd scene, aka perform segue
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        } else {
            print("record error")
            
        }
        
    }
}


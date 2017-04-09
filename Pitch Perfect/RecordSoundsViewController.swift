//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Brown on 1/26/16.
//  Copyright © 2016 Incipire, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        //TODO: Record the user's voice
        print("In RecordAudio")
        recordingLabel.isHidden = false
        recordButton.isEnabled = false
        stopButton.isHidden = false
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "tmp_audio.wav"
        
        let filePath = URL(fileURLWithPath:dirPath, isDirectory:true).appendingPathComponent(recordingName)
            //URL.baseURL(withPathComponents: pathArray)
        
            print(filePath)
        
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        
            try!audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag)
        {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = audioRecorder.url
            recordedAudio.title = audioRecorder.url.lastPathComponent
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        }else{
            print("Recording was not successful")
            recordButton.isEnabled = true
            stopButton.isHidden = true
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(_ sender: UIButton) {
        recordingLabel.isHidden = true
        recordButton.isEnabled = true
        stopButton.isHidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}


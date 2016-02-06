//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Brown on 1/30/16.
//  Copyright © 2016 Incipire, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var player:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = receivedAudio.filePathUrl
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        do{
            player = try AVAudioPlayer(contentsOfURL: url)
            player.enableRate = true
        }
        catch{
            fatalError("Error loading \(url): \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSoundSlow(sender: AnyObject) {
        player.stop()
        player.rate = 0.5
        player.play()
    }

    @IBAction func playVader(sender: UIButton) {
        playAudioWithVariablePitch(-500)
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
        
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        player.stop()
        player.rate = 2.0
        player.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        player.stop()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

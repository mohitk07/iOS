//
//  ViewController.swift
//  Pitch
//
//  Created by Mohit Kumar on 31/12/20.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var RecordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    
    @IBAction func RecordAudio(_ sender: Any)
    {
        RecordingLabel.text = "Recording..."
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        
    }
    
    @IBAction func stoprecording(_ sender: Any) {
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        RecordingLabel.text = "Tap to record"
        audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("Recording was not succesful.")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
}


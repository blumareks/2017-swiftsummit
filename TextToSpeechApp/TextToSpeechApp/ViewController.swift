//
//  ViewController.swift
//  TextToSpeechApp
//
//  Created by Marek Sadowski on 10/13/17.
//  Copyright © 2017 Marek Sadowski. All rights reserved.
//

import UIKit
import TextToSpeechV1 //importing Watson TTS service
import AVFoundation   //importing AVFoundation for AVAudioPlayer



class ViewController: UIViewController {

    @IBOutlet weak var speakText: UITextField!
    @IBOutlet weak var voiceSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func speakButtonPressed(_ sender: Any) {
        NSLog("Speak button pressed, speak:" + speakText.text!  + "voice segment" + voiceSegment.selectedSegmentIndex.description)
        
        let username = "<username>" //the user from the step above
        let password = "<password>"  //the password from the step above
        let textToSpeech = TextToSpeech(username: username, password: password)
        
        let text = speakText.text!
        let failure = { (error: Error) in print(error) }
        textToSpeech.synthesize(text, voice:
            ("0"==voiceSegment.selectedSegmentIndex.description ? SynthesisVoice.us_Michael.rawValue : ( "1"==voiceSegment.selectedSegmentIndex.description ? SynthesisVoice.us_Allison.rawValue : SynthesisVoice.gb_Kate.rawValue)
        ), failure: failure) { data in
            var audioPlayer: AVAudioPlayer // see note below
            audioPlayer = try! AVAudioPlayer(data: data)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            sleep(10)
        }
    }
    
}


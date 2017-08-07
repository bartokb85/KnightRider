//
//  InterfaceController.swift
//  KnightRider WatchKit Extension
//
//  Created by Balint Bartok on 2017. 08. 03..
//  Copyright © 2017. Balint Bartok. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class InterfaceController: WKInterfaceController {

    @IBOutlet var ButtonOil: WKInterfaceButton!
    @IBOutlet var ButtonAir: WKInterfaceButton!
    @IBOutlet var ButtonP1: WKInterfaceButton!
    @IBOutlet var ButtonP2: WKInterfaceButton!
    
    @IBOutlet var voiceBox: WKInterfaceImage!
    
    var buttonOilIsOn = true
    var buttonAirIsOn = false
    var buttonP1IsOn = false
    var buttonP2IsOn = false

    var currentVoiceBoxImageIndex = 1
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.voiceBox.setImageNamed("voicebox-4.png")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    @IBAction func ButtonOilPressed() {
        
        playAudio(filename: "button-pursuit-mode")
        animateVoiceBox()
        var imageName: String
        
        if buttonOilIsOn {
            
            imageName = "button-oil-off.png"
        } else {
            
            imageName = "button-oil-on.png"
        }
        
        self.ButtonOil.setBackgroundImageNamed(imageName)
        buttonOilIsOn = !buttonOilIsOn
    }
    
    @IBAction func ButtonAirPressed() {
        
        playAudio(filename: "button-right-away")
        animateVoiceBox()
        var imageName: String
        
        if buttonAirIsOn {
            
            imageName = "button-air-off.png"
        } else {
            
            imageName = "button-air-on.png"
        }
        
        self.ButtonAir.setBackgroundImageNamed(imageName)
        buttonAirIsOn = !buttonAirIsOn
    }
    
    @IBAction func ButtonP1Pressed() {

        playAudio(filename: "kitt")
        animateVoiceBox()
        var imageName: String
        
        if buttonP1IsOn {
            
            imageName = "button-p1-off.png"
        } else {
            
            imageName = "button-p1-on.png"
        }
        
        self.ButtonP1.setBackgroundImageNamed(imageName)
        buttonP1IsOn = !buttonP1IsOn
    }
    
    @IBAction func ButtonP2Pressed() {
        
        playAudio(filename: "button-systems-go")
        animateVoiceBox()
        var imageName: String
        
        if buttonP2IsOn {
            
            imageName = "button-p2-off.png"
        } else {
            
            imageName = "button-p2-on.png"
        }
        
        self.ButtonP2.setBackgroundImageNamed(imageName)
        buttonP2IsOn = !buttonP2IsOn
    }
    
    func animateVoiceBox() {
        
        if currentVoiceBoxImageIndex < 12 {
            
            currentVoiceBoxImageIndex += 1
            self.voiceBox.setImageNamed(String(format: "voicebox-%d", currentVoiceBoxImageIndex))
            Timer.scheduledTimer(timeInterval: 0.10, target: self, selector: #selector(animateVoiceBox), userInfo: nil, repeats: false)
        } else {
            
            currentVoiceBoxImageIndex = 0
            self.ButtonOil.setBackgroundImageNamed("button-oil-off.png")
            self.ButtonAir.setBackgroundImageNamed("button-air-off.png")
            self.ButtonP1.setBackgroundImageNamed("button-p1-off.png")
            self.ButtonP2.setBackgroundImageNamed("button-p2-off.png")
        }
    }
    
    var _audioPlayer : AVAudioPlayerNode!
    var _audioEngine : AVAudioEngine!
    
    func playAudio(filename:String) {
        
        if (_audioPlayer==nil) {
            _audioPlayer = AVAudioPlayerNode()
            _audioEngine = AVAudioEngine()
            _audioEngine.attach(_audioPlayer)
            
            let stereoFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
            _audioEngine.connect(_audioPlayer, to: _audioEngine.mainMixerNode, format: stereoFormat)
            
            do {
                
                if !_audioEngine.isRunning {
                    try _audioEngine.start()
                }
                
            } catch {}
            
        }
        
        
        if let path = Bundle.main.path(forResource: filename, ofType: "mp3") {
            
            let fileUrl = URL(fileURLWithPath: path)
            
            do {
                let asset = try AVAudioFile(forReading: fileUrl)
                
                _audioPlayer.scheduleFile(asset, at: nil, completionHandler: nil)
                _audioPlayer.play()
                
            } catch {
                print ("asset error")
            }
            
        }

    }
}

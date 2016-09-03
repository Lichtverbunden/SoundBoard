//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Ken Krippeler on 02.09.16.
//  Copyright © 2016 Lichtverbunden. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController
{
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL: URL?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder()
    {
        do
        {
            // Create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            // Create URL for the audio file
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            print("#############################")
            print(audioURL)
            print("#############################")
            
            // Create settings for the AudioRecorder
            var settings: [String:Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            // Create AudioRecorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError
        {
            print(error)
        }
    }
    
    @IBAction func recordTapped(_ sender: AnyObject)
    {
        if audioRecorder!.isRecording
        {
            // Stop the recording
            audioRecorder?.stop()
            
            // Change button title to Record
            recordButton.setTitle("Record", for: .normal)
            
            // Enable the Play and Add button
            playButton.isEnabled = true
            addButton.isEnabled = true
        }
        else
        {
            // Start the recording
            audioRecorder?.record()
            
            // Change button title to Stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func playTapped(_ sender: AnyObject)
    {
        do
        {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        }
        catch
        {
        
        }
    }
    
    @IBAction func addTapped(_ sender: AnyObject)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    
}

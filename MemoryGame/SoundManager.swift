import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect{
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect:SoundEffect) {
        
        var soundFilename = ""
        
        switch effect {
            case .flip:
                soundFilename = "cardflip"
                
            case .match:
                soundFilename = "dingcorrect"
                
            case .nomatch:
                soundFilename = "dingwrong"
                
            case .shuffle:
                soundFilename = "shuffle"
            
        }
        
        //get the path to the resource
       let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        
        //check that it's not nil
        guard bundlePath != nil else {
            //couldn't findthe resource, exit
            return
        }
        
       let url = URL(fileURLWithPath: bundlePath!)
        
        do{
            //create the audioplayer
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            //play the sound effect
            audioPlayer?.play()
        }
        catch{
            print("couldn't create an audio player")
            return
        }
    }
}


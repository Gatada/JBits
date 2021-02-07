//
//  AudioDelegate.swift
//  JBits
//
//  Created by Johan Basberg on 05/01/2021.
//

/* SETUP AUDIODELEGATE
 ----------------------------------------------------------------------------
 
 1. Initialize the AudioDelegate.
    This can be done in the AppDelegate, or more locally in each
    ViewController - or wherever you play audio.
 
 2. Assign the
 
 2. Conform to AudioDelegateAssetProvider.
    You need to conform to the protocol and assign the instance as the audio
    provider. You conform with something like this:
 
    extension MyViewController: AudioDelegateAssetProvider {
    
        var audioAssets: [AudioDelegateAsset] {
            Sound.allCases
        }
    
        var isAudioMuted: Bool {
            UserDefaults.standard.bool(forKey: "Muting Audio")
        }
    }
 
    And you assign the audio provider by calling:
    audioDelegate.assignAssetProvider(self)
    
 3. Create an entity that conforms to the AudioDelegateAsset protocol.
    I recommend using an enum. If all your audio files have the same file extension
    you can do this very simply:
 
    public enum Sound: String, AudioDelegateAsset, CaseIterable {
        case some = "someSoundFile"
        case another = "anotherSoundFile"
        case greatness = "greatAudio"

        public var filename: String {
            rawValue
        }

        public var filetype: String {
            "caf"
        }
    }
 
    Otherwise something like this will do the trick:
 
    public enum Sound: String, AudioDelegateAsset, CaseIterable {
        case some = "someSoundFile"
        case another = "anotherSoundFile"
        case greatness = "greatAudio.wav"
   
        public var filename: String {
            rawValue.components(separatedBy: ".").first!
        }
   
        public var filetype: String {
            let comp = rawValue.components(separatedBy: ".")
            if comp.count == 2 {
                return comp.last!
            } else {
                return "caf"
            }
        }
    }
 
 4. Whenever you need to play a Sound, you notify the AudioDelegate.
    I would recommend creating a helper method to handle this:
 
    func play(_ sound: Sound) {
        let userInfo = ["AudioDelegateAsset": sound]
        NotificationCenter.default.post(name: AudioDelegate.playAudio, object: self, userInfo: userInfo)
    }

 5. Done!
    Now AudioDelegate should work as intended. For the sake of tidiness, I put
    both the enum and the play method in the extension:
 
    extension MyViewController: AudioDelegateAssetProvider {
    
        public enum Sound: String, AudioDelegateAsset, CaseIterable {
            case some = "someSoundFile"
            case another = "anotherSoundFile"
            case greatness = "greatAudio"

            public var filename: String {
                rawValue
            }
   
            public var filetype: String {
                "caf"
            }
        }
    
        var audioAssets: [AudioDelegateAsset] {
            Sound.allCases
        }
    
        var isAudioMuted: Bool {
            UserDefaults.standard.bool(forKey: "Muting Audio")
        }
    
        func play(_ sound: Sound) {
            let userInfo = ["AudioDelegateAsset": sound]
            NotificationCenter.default.post(name: AudioDelegate.playAudio, object: self, userInfo: userInfo)
        }
    }


 ---------------------------------------------------------------------------- */


import Foundation
import AVFoundation

public protocol AudioDelegateAsset {
    var filename: String { get }
    var filetype: String { get }
    
    /// The volume of the sound being played.
    ///
    /// A value between 0 and 1, where 0 is inaudible and
    /// 1 means playback at recorded level.
    var playbackVolume: Float { get }
}

private extension AudioDelegateAsset {
    var rawValue: String {
        "\(filename).\(filetype)"
    }
}

public protocol AudioDelegateAssetProvider {
    var audioAssets: [AudioDelegateAsset] { get }
    var isAudioMuted: Bool { get }
    
    /// This asset, if provided, will be played if the requested asset is still playing.
    ///
    /// It would be best to use an audio asset with very short duration.
    var fallBackAudioAsset: AudioDelegateAsset? { get }
}

public class AudioDelegate {

    // MARK: - Public API
    
    static public let playAudio = Notification.Name("Play Audio")

    public func assignAssetProvider(_ provider: AudioDelegateAssetProvider) {
        self.assetProvider = provider
    }
    
    public func refreshAudioAssets() {
        guard let provider = self.assetProvider else {
            assertionFailure("No asset provider has been set")
            return
        }
        audioPlayers = [:]
        prepareAudioAssets(provider.audioAssets)
        if let fallbackAsset = provider.fallBackAudioAsset {
            prepareAudioAssets([fallbackAsset])
        }
    }

    
    // MARK: - Private Properties
    
    private var audioPlayers: [String: AVAudioPlayer]
    
    private var assetProvider: AudioDelegateAssetProvider?
    
    
    // MARK: - Life Cycle
    
    public init() {
        audioPlayers = [:]
        if setupAudioSession() {
            addObservers()
        }
    }
    
    
    // MARK: - Setup
    
    private func setupAudioSession() -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            return true
        } catch {
            // Failed to setup the audio session.
            // App will be soundless.
            return false
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(play(_:)), name: AudioDelegate.playAudio, object: nil)
    }
    
    private func prepareAudioAssets(_ assets: [AudioDelegateAsset]) {
        assert(!assets.isEmpty, "There are no assets to setup.")
        
        func preparePlayerForAsset(_ asset: AudioDelegateAsset) {
            if let path = Bundle.main.path(forResource: asset.filename, ofType: asset.filetype) {
                guard let audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path)) else {
                    assertionFailure("Failed to prepare audio with path: \(path)")
                    return
                }
                audioPlayer.prepareToPlay()
                audioPlayer.volume = asset.playbackVolume
                audioPlayers[asset.rawValue] = audioPlayer
            }
        }
        
        for asset in assets {
            preparePlayerForAsset(asset)
        }
    }
    
    
    // MARK: - Interaction
    
    @objc func play(_ notification: Notification) {
        
        Log.da("Notification to play sound received..", log: .info)
        
        guard let provider = assetProvider else {
            assertionFailure("No asset provider defined for AudioDelegate")
            return
        }

        guard !provider.isAudioMuted else {
            Log.da("Sounds are muted, bailing.", log: .info)
            return
        }

        guard let asset = notification.userInfo?["AudioDelegateAsset"] as? AudioDelegateAsset else {
            assertionFailure("Notification did not contain a valid AudioDelegateAsset")
            return
        }
        
        if audioPlayers[asset.rawValue]?.isPlaying == true {
            // Fallback to very short alternative sound.
            if let asset = assetProvider?.fallBackAudioAsset {
                audioPlayers[asset.rawValue]?.play()
                Log.da("🎵 Requested player still playing, playing fallback sound..", log: .info)
            }
        } else {
            audioPlayers[asset.rawValue]?.play()
            Log.da("🎵 Playing \"\(asset.rawValue)\"..", log: .info)
        }
            
    }
}

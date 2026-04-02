import AVFoundation
import UIKit
import Combine

struct SoundItem: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let filename: String  // filename without extension, e.g. "bark" for bark.mp3
}

let emojis = ["💥","🐶","💦","🔔","😱","💨","🦁","👏","🔫","🪙",
               "⚡️","🎵","🎶","🥁","🎸","🎺","🎻","🪗","📯","🔈",
               "🔉","🔊","📢","📣","🎙","🎚","🎛","📻","🎷","🎹",
               "🌊","💫","✨","🌟","⭐️","🌈","🎉","🎊","🎈","🎁",
               "🏆","🥇","🎯","🎮","🕹","🃏","🎲","🎰","🧨","🪄",
               "🔮","🧿","🪬","🧲","💎","🔑","🗝","🔐","🔒","🔓"]

class SoundManager: ObservableObject {
    @Published var lastPlayedSound: SoundItem?
    private var player: AVAudioPlayer?

    let sounds: [SoundItem] = (0...59).map { i in
        SoundItem(
            name: String(format: "%02d", i),
            emoji: emojis[i],
            filename: String(format: "%02d", i)
        )
    }

    func playRandom() {
        guard let sound = sounds.randomElement() else { return }
        play(sound)
    }

    func play(_ sound: SoundItem) {
        lastPlayedSound = sound

        guard let url = Bundle.main.url(forResource: sound.filename, withExtension: "mp3") else {
            print("⚠️ Sound file not found: \(sound.filename).mp3 — check the filename in SoundManager and that the file is added to the Xcode target.")
            return
        }

        do {
            // Plays even when the silent switch is on
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("⚠️ Playback error: \(error)")
        }

        // Haptic punch
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}

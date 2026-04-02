import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var soundManager = SoundManager()
    @State private var slapScale: CGFloat = 1.0
    @State private var rotation: Double = 0
    @State private var rippleScale: CGFloat = 0.5
    @State private var rippleOpacity: Double = 0
    @State private var offsetX: CGFloat = 0
    @State private var glowRadius: CGFloat = 20

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "0d0d0d"), Color(hex: "1a0a0a"), Color(hex: "2d0a0a")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Subtle noise grain overlay
            Rectangle()
                .fill(.white.opacity(0.02))
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Header ──────────────────────────────────────────────
                VStack(spacing: 6) {
                    HStack(spacing: 0) {
                        Text("i")
                            .font(.system(size: 42, weight: .thin, design: .rounded))
                            .foregroundColor(Color(hex: "ff3b3b"))
                        Text("Slap")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                    Text("Slap your phone. Get a sound.")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(1)
                }
                .padding(.top, 64)
                .padding(.bottom, 44)

                // ── Central icon ─────────────────────────────────────────
                ZStack {
                    // Outer glow rings
                    ForEach(0..<3) { i in
                        Circle()
                            .stroke(
                                Color(hex: "ff3b3b").opacity(rippleOpacity / Double(i + 1)),
                                lineWidth: 1.5
                            )
                            .frame(width: 150, height: 150)
                            .scaleEffect(rippleScale + CGFloat(i) * 0.5)
                    }

                    // Main circle
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color(hex: "ff3b3b"), Color(hex: "8b0000")],
                                center: .topLeading,
                                startRadius: 5,
                                endRadius: 110
                            )
                        )
                        .frame(width: 150, height: 150)
                        .shadow(
                            color: Color(hex: "ff3b3b").opacity(0.6),
                            radius: glowRadius, x: 0, y: 0
                        )

                    // Emoji
                    Text(soundManager.lastPlayedSound?.emoji ?? "👋")
                        .font(.system(size: 64))
                        .scaleEffect(slapScale)
                        .rotationEffect(.degrees(rotation))
                        .offset(x: offsetX)
                }
                .frame(height: 200)
                .padding(.bottom, 32)

                // ── Last played ──────────────────────────────────────────
                VStack(spacing: 4) {
                    Text("LAST SLAP")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.3))
                        .tracking(3)

                    Text(soundManager.lastPlayedSound?.name ?? "—")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .animation(.spring(response: 0.3), value: soundManager.lastPlayedSound?.name)
                }
                .padding(.bottom, 40)

                // ── Sound chips ──────────────────────────────────────────
                VStack(alignment: .leading, spacing: 10) {
                    Text("SOUNDS")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.3))
                        .tracking(3)
                        .padding(.leading, 28)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(soundManager.sounds) { sound in
                                SoundChip(
                                    sound: sound,
                                    isActive: soundManager.lastPlayedSound?.id == sound.id
                                )
                                .onTapGesture {
                                    soundManager.play(sound)
                                    triggerSlapAnimation()
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 4)
                    }
                }
                .padding(.bottom, 36)

                Spacer()

                // ── Footer hint ──────────────────────────────────────────
                HStack(spacing: 8) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "ff3b3b").opacity(0.7))
                    Text("tap a chip  ·  or slap the phone")
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(.bottom, 40)
            }
        }
        .onSlap {
            soundManager.playRandom()
            triggerSlapAnimation()
        }
    }

    // MARK: - Animation

    private func triggerSlapAnimation() {
        // Impact squish
        withAnimation(.interpolatingSpring(stiffness: 600, damping: 5)) {
            slapScale = 0.65
            offsetX = CGFloat.random(in: -14...14)
            rotation = Double.random(in: -22...22)
            glowRadius = 50
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.interpolatingSpring(stiffness: 180, damping: 9)) {
                slapScale = 1.25
                offsetX = 0
                glowRadius = 40
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                slapScale = 1.0
                rotation = 0
                glowRadius = 20
            }
        }

        // Ripple burst
        rippleScale = 0.3
        rippleOpacity = 1.0
        withAnimation(.easeOut(duration: 0.75)) {
            rippleScale = 2.4
            rippleOpacity = 0
        }
    }
}

// MARK: - Sound Chip

struct SoundChip: View {
    let sound: SoundItem
    let isActive: Bool

    var body: some View {
        HStack(spacing: 6) {
            Text(sound.emoji)
                .font(.system(size: 15))
            Text(sound.name)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(isActive ? .white : .white.opacity(0.65))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(
            Capsule()
                .fill(isActive
                      ? Color(hex: "ff3b3b")
                      : Color.white.opacity(0.07))
                .overlay(
                    Capsule()
                        .stroke(
                            isActive ? Color.clear : Color.white.opacity(0.08),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: isActive ? Color(hex: "ff3b3b").opacity(0.45) : .clear,
                    radius: 10, x: 0, y: 4
                )
        )
        .animation(.spring(response: 0.25), value: isActive)
    }
}

// MARK: - Hex Color

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8)  & 0xFF) / 255.0
        let b = Double(int         & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    ContentView()
}

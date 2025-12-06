//
//  VideoPlayerView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import AVKit

enum PlayerState: Equatable {
    case loading
    case playing
    case paused
    case error(String)
}

struct VideoPlayerView: View {
    @Bindable var day: AdventDay
    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer?
    @State private var isAppearing = false
    @State private var showControls = true
    @State private var playerState: PlayerState = .loading
    @State private var playerObserver: Any?
    @State private var loopObserver: Any?
    @State private var hideControlsTask: Task<Void, Never>?
    @State private var showTitle = true

    private var isPlaying: Bool {
        playerState == .playing
    }

    private let iconColor: Color = .christmasRed

    @ViewBuilder
    private var centerButtonContent: some View {
        Group {
            switch playerState {
            case .loading:
                ProgressView()
            case .playing:
                Image(systemName: "pause.fill")
                    .font(.title)
            case .paused:
                Image(systemName: "play.fill")
                    .font(.title)
                    .offset(x: 3)
            case .error:
                Image(systemName: "arrow.clockwise")
                    .font(.title)
            }
        }
        .foregroundColor(iconColor)
        .tint(iconColor)
    }

    var body: some View {
        ZStack {
            // Background
            Color.appBackground.ignoresSafeArea()

            // Video Layer
            if let player = player {
                CustomVideoPlayer(player: player)
                    .ignoresSafeArea()
            }


            // Tap to toggle controls
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    if showControls {
                        // Already showing, extend the delay
                        scheduleHideControls()
                    } else {
                        // Show controls
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showControls = true
                        }
                        scheduleHideControls()
                    }
                }

            // Top Bar (always visible)
            VStack {
                HStack {
                    Button {
                        player?.pause()
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }

                    Spacer()

                    if let url = URL(string: day.videoURL) {
                        ShareLink(item: url) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2.weight(.semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 44)

                Spacer()
            }

            // Controls Overlay (auto-hide)
            if showControls {
                VStack(spacing: 0) {
                    Spacer()

                    // Center Play Button (4 states: loading, playing, paused, error)
                    Button {
                        handleCenterButtonTap()
                    } label: {
                        Circle()
                            .fill(Color.cream.opacity(0.9))
                            .frame(width: 70, height: 70)
                            .overlay {
                                centerButtonContent
                            }
                    }
                    .disabled(playerState == .loading)

                    Spacer()

                    // Title Text
                    Text(day.title)
                        .font(.appFont(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                        .opacity(showTitle ? 1 : 0)

                    // Bottom Toolbar
                    HStack(spacing: 24) {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                day.isFavorite.toggle()
                            }
                        } label: {
                            Image(systemName: day.isFavorite ? "heart.fill" : "heart")
                                .font(.title3)
                                .foregroundColor(.white)
                                .scaleEffect(day.isFavorite ? 1.1 : 1.0)
                        }

                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showTitle.toggle()
                            }
                        } label: {
                            Image(systemName: showTitle ? "chevron.down" : "chevron.up")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(Color.beige.opacity(0.9))
                    )
                    .padding(.bottom, 40)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showControls)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAppearing = true
            }
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
            hideControlsTask?.cancel()
            if let observer = playerObserver {
                NotificationCenter.default.removeObserver(observer)
            }
            if let observer = loopObserver {
                NotificationCenter.default.removeObserver(observer)
            }
            player = nil
        }
    }

    private func setupPlayer() {
        guard let url = URL(string: day.videoURL) else {
            playerState = .error("無效的影片網址")
            return
        }

        playerState = .loading
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        // Observe player item status
        playerObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            playerState = .error("播放失敗")
        }

        // Loop video when finished
        loopObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            player?.seek(to: .zero)
            player?.play()
        }

        // Observe when ready to play
        Task {
            do {
                let status = try await playerItem.asset.load(.isPlayable)
                if status {
                    await MainActor.run {
                        playerState = .playing
                        player?.play()
                        scheduleHideControls()
                    }
                } else {
                    await MainActor.run {
                        playerState = .error("無法播放")
                    }
                }
            } catch {
                await MainActor.run {
                    playerState = .error("連線失敗")
                }
            }
        }
    }

    private func handleCenterButtonTap() {
        switch playerState {
        case .loading:
            break
        case .playing:
            player?.pause()
            playerState = .paused
            hideControlsTask?.cancel()
        case .paused:
            player?.play()
            playerState = .playing
            scheduleHideControls()
        case .error:
            retryLoading()
        }
    }

    private func retryLoading() {
        player?.pause()
        player = nil
        setupPlayer()
    }

    private func scheduleHideControls() {
        hideControlsTask?.cancel()
        hideControlsTask = Task {
            try? await Task.sleep(for: .seconds(3))
            if !Task.isCancelled && isPlaying {
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showControls = false
                    }
                }
            }
        }
    }
}

// Custom Video Player without default controls
struct CustomVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}

#Preview {
//    VideoPlayerView(day: AdventDay(day: 1, videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", title: "Day 1 Surprise"))
    VideoPlayerView(day: AdventDay(day: 1, videoURL: "https://drive.google.com/uc?export=download&id=1OMke27-tI3CVXvrnLauTAVmX8JdZNaEc", title: "Day 1 Surprise"))
}

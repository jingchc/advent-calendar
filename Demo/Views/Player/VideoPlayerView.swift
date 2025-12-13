//
//  VideoPlayerView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import AVKit

// MARK: - Player State

enum PlayerState: Equatable {
    case loading, playing, paused
    case error(String)
}

// MARK: - View

struct VideoPlayerView: View {
    @Bindable var day: AdventDay
    @State private var player: AVPlayer?
    @State private var playerState: PlayerState = .loading
    @State private var showControls = true
    @State private var showTitle = true
    @State private var controlsTask: Task<Void, Never>?

    private var isPlaying: Bool { playerState == .playing }

    var body: some View {
        ZStack {
            videoLayer
            tapLayer
            controlsOverlay
        }
        .appBackground()
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(AccessibilityID.VideoPlayer.container)
        .toolbar { shareButton }
        .onAppear { setupPlayer() }
        .onDisappear { cleanup() }
    }
}

// MARK: - Subviews

private extension VideoPlayerView {
    @ViewBuilder
    var videoLayer: some View {
        if let player {
            CustomVideoPlayer(player: player)
                .ignoresSafeArea()
        }
    }

    var tapLayer: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                if !showControls {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showControls = true
                    }
                }
                scheduleHideControls()
            }
    }

    var controlsOverlay: some View {
        VStack(spacing: 0) {
            Spacer()
            centerButton
            Spacer()
            titleText
            bottomToolbar
        }
        .opacity(showControls ? 1 : 0)
        .scaleEffect(showControls ? 1 : 0.95)
        .allowsHitTesting(showControls)
        .animation(.easeInOut(duration: 0.3), value: showControls)
        .simultaneousGesture(TapGesture().onEnded { _ in scheduleHideControls() })
    }

    var centerButton: some View {
        Button(action: handleCenterButtonTap) {
            Circle()
                .fill(Color.cream.opacity(0.9))
                .frame(width: 70, height: 70)
                .overlay { centerButtonIcon }
        }
        .disabled(playerState == .loading)
        .accessibilityIdentifier(AccessibilityID.VideoPlayer.playPauseButton)
    }

    @ViewBuilder
    var centerButtonIcon: some View {
        Group {
            switch playerState {
            case .loading:
                ProgressView()
            case .playing:
                Image(systemName: "pause.fill").font(.title)
            case .paused:
                Image(systemName: "play.fill").font(.title).offset(x: 3)
            case .error:
                Image(systemName: "arrow.clockwise").font(.title)
            }
        }
        .foregroundColor(.christmasRed)
        .tint(.christmasRed)
    }

    var titleText: some View {
        Text(day.title)
            .font(.appFont(size: 22, weight: .bold))
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
            .padding(.horizontal, 40)
            .multilineTextAlignment(.center)
            .padding(.bottom, 20)
            .opacity(showTitle ? 1 : 0)
            .animation(.easeInOut(duration: 0.2), value: showTitle)
    }

    var bottomToolbar: some View {
        HStack(spacing: 24) {
            favoriteButton
            toggleTitleButton
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 14)
        .background(Capsule().fill(Color.beige.opacity(0.9)))
        .padding(.bottom, 40)
    }

    var favoriteButton: some View {
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
        .accessibilityIdentifier(AccessibilityID.VideoPlayer.favoriteButton)
    }

    var toggleTitleButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                showTitle.toggle()
            }
        } label: {
            Image(systemName: showTitle ? "chevron.down" : "chevron.up")
                .font(.title3.weight(.semibold))
                .foregroundColor(.white)
        }
        .accessibilityIdentifier(AccessibilityID.VideoPlayer.toggleTitleButton)
    }

    @ToolbarContentBuilder
    var shareButton: some ToolbarContent {
        if let url = URL(string: day.videoURL) {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: url)
            }
        }
    }
}

// MARK: - Actions

private extension VideoPlayerView {
    func setupPlayer() {
        guard let url = URL(string: day.videoURL) else {
            playerState = .error("無效的影片網址")
            return
        }

        playerState = .loading
        let playerItem = AVPlayerItem(url: url)
        let newPlayer = AVPlayer(playerItem: playerItem)
        player = newPlayer

        Task {
            do {
                let isPlayable = try await playerItem.asset.load(.isPlayable)
                guard isPlayable else {
                    playerState = .error("無法播放")
                    return
                }
                playerState = .playing
                newPlayer.play()
                scheduleHideControls()
            } catch {
                playerState = .error("連線失敗")
                return
            }

            for await _ in NotificationCenter.default.notifications(named: .AVPlayerItemDidPlayToEndTime, object: playerItem) {
                await newPlayer.seek(to: .zero)
                newPlayer.play()
            }
        }
    }

    func handleCenterButtonTap() {
        switch playerState {
        case .loading:
            break
        case .playing:
            player?.pause()
            playerState = .paused
            controlsTask?.cancel()
        case .paused:
            player?.play()
            playerState = .playing
            scheduleHideControls()
        case .error:
            setupPlayer()
        }
    }

    func scheduleHideControls() {
        controlsTask?.cancel()
        controlsTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(3))
            guard !Task.isCancelled, isPlaying else { return }
            withAnimation(.easeInOut(duration: 0.3)) {
                showControls = false
            }
        }
    }

    func cleanup() {
        controlsTask?.cancel()
        player?.pause()
        player = nil
    }
}

// MARK: - Custom Video Player

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

// MARK: - Preview

#Preview {
    VideoPlayerView(day: AdventDay(day: 1, videoURL: "https://drive.google.com/uc?export=download&id=1OMke27-tI3CVXvrnLauTAVmX8JdZNaEc", title: "Day 1 Surprise"))
}

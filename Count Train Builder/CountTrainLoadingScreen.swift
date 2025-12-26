import SwiftUI

// MARK: - Протоколы для улучшения расширяемости

protocol ProgressDisplayable {
    var progressPercentage: Int { get }
}

protocol BackgroundProviding {
    associatedtype BackgroundContent: View
    func makeBackground() -> BackgroundContent
}

// MARK: - Расширенная структура загрузки

struct CountTrainLoadingOverlay: View, ProgressDisplayable {
    let progress: Double
    @State private var angle: Double = 0
    @State private var glow: Bool = false
    var progressPercentage: Int { Int(progress * 100) }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Animated gradient background (no images)
                AngularGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#0F2027"),
                        Color(hex: "#203A43"),
                        Color(hex: "#2C5364"),
                        Color(hex: "#0F2027"),
                    ]),
                    center: .center,
                    angle: .degrees(angle)
                )
                .ignoresSafeArea()
                .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: angle)
                .onAppear { angle = 360 }

                VStack(spacing: 22) {
                    // Glassmorphism card
                    VStack(spacing: 16) {
                        Image(systemName: "train.side.front.car")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 56, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "#22D3EE"), Color(hex: "#A855F7")],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )

                        Text("CountTrain")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Preparing your journey…")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.75))

                        CountTrainProgressBar(progress: progress)
                            .frame(height: 10)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text("\(progressPercentage)%")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 22)
                    .background(
                        Color.white.opacity(0.10)
                            .blur(radius: 0)
                    )
                    .background(
                        LinearGradient(colors: [Color.white.opacity(0.10), Color.white.opacity(0.04)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                    )
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 12)
                    .padding(.horizontal, 28)
                }
            }
        }
    }
}

// MARK: - Фоновые представления

struct CountTrainBackground: View, BackgroundProviding {
    func makeBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#0B0F1A"),
                Color(hex: "#0F172A"),
                Color(hex: "#111827"),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).ignoresSafeArea()
    }

    var body: some View {
        makeBackground()
    }
}

// MARK: - Circular Spinner

private struct CountTrainCircularSpinner: View {
    let progress: Double
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: 10)

            // Progress ring
            Circle()
                .trim(from: 0, to: max(0.02, min(1.0, progress)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#22D3EE"), // cyan
                            Color(hex: "#6366F1"), // indigo
                            Color(hex: "#A855F7"), // purple
                            Color(hex: "#F472B6"), // pink
                        ]),
                        center: .center,
                        angle: .degrees(rotation)
                    ),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: Color(hex: "#22D3EE").opacity(0.35), radius: 8)
                .animation(.easeInOut(duration: 0.25), value: progress)

            // Rotating highlight arc
            Circle()
                .trim(from: 0.0, to: 0.12)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.9), Color.clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(rotation))
                .rotationEffect(.degrees(-90))
                .blendMode(.screen)
        }
        .onAppear {
            withAnimation(.linear(duration: 1.8).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Linear Progress Bar

private struct CountTrainProgressBar: View {
    let progress: Double
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let clamped = max(0.0, min(1.0, progress))
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.12))
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#22D3EE"), Color(hex: "#6366F1"), Color(hex: "#A855F7")],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .frame(width: width * clamped)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
                    )
            }
            .animation(.easeInOut(duration: 0.25), value: clamped)
        }
    }
}

// MARK: - Previews

#if canImport(SwiftUI)
import SwiftUI
#endif

// Use availability to keep using the modern #Preview API on iOS 17+ and provide a fallback for older versions
@available(iOS 17.0, *)
#Preview("Vertical") {
    CountTrainLoadingOverlay(progress: 0.2)
}

@available(iOS 17.0, *)
#Preview("Horizontal", traits: .landscapeRight) {
    CountTrainLoadingOverlay(progress: 0.2)
}

// Fallback previews for iOS < 17
struct CountTrainLoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountTrainLoadingOverlay(progress: 0.2)
                .previewDisplayName("Vertical (Legacy)")

            CountTrainLoadingOverlay(progress: 0.2)
                .previewDisplayName("Horizontal (Legacy)")
                .previewLayout(.fixed(width: 812, height: 375)) // Simulate landscape on older previews
        }
    }
}

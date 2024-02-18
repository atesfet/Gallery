import SwiftUI

private func createColors(_ red: Double, _ green: Double, _ blue: Double) -> Color {
    Color(red: red / 255, green: green / 255, blue: blue / 255)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

// pinkish colors
//private let gradientStart = Color(hex: 0xFEC194)
//private let gradientEnd = Color(hex: 0xFF0061)

// green and blueish color
 private let gradientStart = createColors(82, 215, 157)
 private let gradientEnd = createColors(51, 167, 175)

private let gradient = LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]), startPoint: .top, endPoint: .bottom)
private let maskGradient = LinearGradient(gradient: Gradient(colors: [.black]), startPoint: .top, endPoint: .bottom)

private let maxSize: CGFloat = 120
private let minSize: CGFloat = 30
private let inhaleTime: Double = 5
private let exhaleTime: Double = 3
private let pauseTime: Double = 0.5

private let numberOfPetals = 4
private let bigAngle = 360 / numberOfPetals
private let smallAngle = bigAngle / 2

private let ghostMaxSize: CGFloat = maxSize * 0.99
private let ghostMinSize: CGFloat = maxSize * 0.95

private struct Petals: View {
    let size: CGFloat
    let inhaling: Bool
    var isMask = false
    var body: some View {
        let petalsGradient = isMask ? maskGradient : gradient
        ZStack {
            ForEach(0..<numberOfPetals) { index in
                petalsGradient
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .mask(
                        Circle()
                            .frame(width: size, height: size)
                            .offset(x: inhaling ? size * 0.5 : 0)
                            .rotationEffect(.degrees(Double(bigAngle * index)))
                    )
                    .blendMode(isMask ? .normal : .screen)
            }
        }
    }
}


struct BreathingAnimationView: View {
    @State private var isBreathingIn = false
    @State private var rotationAngle: Double = 0
    @State private var showWelcome = true
    @State private var showMenu = false
    @State private var showExercise = false
    @State private var showCompletion = false
    @State private var animationDuration: TimeInterval = 4
    @State private var exerciseDuration: TimeInterval = 30
    @State var showNewView = false

    @Environment(\.dismiss) private var dismiss
    @State private var petalSize = minSize
    @State private var inhaling = false
    @State private var ghostSize = ghostMaxSize
    @State private var ghostBlur: CGFloat = 0
    @State private var ghostOpacity: Double = 0
    var exitEnvironment: () -> Void
    let numberOfSpheres = 8
    let exerciseOptions: [TimeInterval] = [30, 60, 180] // 30s, 1min, 3min, 5min

    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                let size = geometry.size
                let smallerCircleRadius: CGFloat = 30
                let minCircleRadius = size.width / 10
                let maxCircleRadius = size.width / 6
                let circleRadius = isBreathingIn ? maxCircleRadius : minCircleRadius
                
                ZStack {
                    if showNewView{
                        ImmersiveView()
                    } else if showWelcome {
                        Text("Welcome to Guided Meditation")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                            .transition(.opacity)
                    } else if showMenu {
                        VStack {
                            Text("Choose Duration")
                                .font(.title)
                                .foregroundColor(.white)
                            ForEach(exerciseOptions, id: \.self) { duration in
                                Button("\(Int(duration)) seconds") {
                                    startExercise(duration: duration)
                                }
                                .foregroundColor(.blue)
                                .padding()
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity) // Use the full width available
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the VStack in the GeometryReader
                        .padding()

                    } else if showExercise {
                        ZStack{
                            ZStack {
                                // ghosting for exhaling
                                Petals(size: ghostSize, inhaling: inhaling)
                                    .blur(radius: ghostBlur)
                                    .opacity(ghostOpacity)
                                
                                // the mask is important, otherwise there is a color
                                // 'jump' when exhaling
                                Petals(size: petalSize, inhaling: inhaling, isMask: true)
                                
                                // overlapping petals
                                Petals(size: petalSize, inhaling: inhaling)
                                Petals(size: petalSize, inhaling: inhaling)
                                    .rotationEffect(.degrees(Double(smallAngle)))
                                    .opacity(inhaling ? 0.8 : 0.6)
                            }
                            .rotationEffect(.degrees(Double(inhaling ? bigAngle : -smallAngle)))
                            .drawingGroup()
                        }.onAppear(){
                            performAnimations()
                        }
                        
                        Text(isBreathingIn ? "Exhale" : "Inhale")
                            .font(.title)
                            .foregroundColor(.white)
                            .position(x: size.width / 2, y: size.height - 80)
                        if showCompletion {
                            Text("Good Job!")
                                .font(.title)
                                .foregroundColor(.green)
                            
                            
                        }
                          
                        
                        
                    }
                }
                
                Button("Leave the Environment") {
                    exitEnvironment()
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showWelcome = false
                            showMenu = true
                            
                        }
                    }
                }
            }
            
        }
            
        }
        
        private func startExercise(duration: TimeInterval) {
            exerciseDuration = duration
            withAnimation {
                showMenu = false
                showExercise = true
                startBreathingAnimation()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                withAnimation {
                    showCompletion = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showExercise = false
                        showNewView = true
                    }
                }
            }
        }
        
        private func startBreathingAnimation() {
            Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { timer in
                withAnimation(Animation.easeInOut(duration: animationDuration)) {
                    isBreathingIn.toggle()
                }
            }
            withAnimation(Animation.linear(duration: animationDuration / 2)) {
                rotationAngle += 360
            }
        }
        
        private func performAnimations() {
            withAnimation(.easeInOut(duration: inhaleTime)) {
                inhaling = true
                petalSize = maxSize
            }
            Timer.scheduledTimer(withTimeInterval: inhaleTime + pauseTime, repeats: false) { _ in
                ghostSize = ghostMaxSize
                ghostBlur = 0
                ghostOpacity = 0.8
                
                Timer.scheduledTimer(withTimeInterval: exhaleTime, repeats: false) { _ in
                    withAnimation(.easeOut(duration: exhaleTime)) {
                        ghostBlur = 30
                        ghostOpacity = 0
                    }
                }
                
                withAnimation(.easeInOut(duration: exhaleTime)) {
                    inhaling = false
                    petalSize = minSize
                    ghostSize = ghostMinSize
                }
            }
            
            Timer.scheduledTimer(withTimeInterval: inhaleTime + pauseTime + exhaleTime + pauseTime, repeats: false) { _ in
                
                // endless animation!
                performAnimations()
            }
        }
    
}

    



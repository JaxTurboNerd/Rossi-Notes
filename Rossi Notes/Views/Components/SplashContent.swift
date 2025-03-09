//
//  SplashscreenView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 3/8/25.
//

import SwiftUI

enum AnimationPhase: CaseIterable {
    case beginning, middle, end
    
    var opacity: Double {
        switch self {
        case .beginning: 1.0
        case .middle: 0.5
        case .end: 1.0
        }
    }
    
    var scale: Double {
        switch self {
        case .beginning, .end: 0.8
        case .middle: 1.2
        }
    }
    
    var animation: Animation {
        switch self {
        case .beginning, .end: .bouncy(duration: 0.5)
        case .middle: .easeInOut(duration: 1.0)
        }
    }
}

struct SplashContent: View {
    
    @StateObject var user: Appwrite
    @State private var shouldDisplaySplashView = true
    
    var body: some View {
        ZStack {
            MainBackgroundView()
            VStack {
                Text("Rossi Notes App")
                    .font(.title)
                    .padding(.top)
                Image("Splashscreen")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .phaseAnimator(AnimationPhase.allCases) { content, phase in
                        content
                            .opacity(phase.opacity)
                            .scaleEffect(phase.scale)
                    } animation: { phase in
                        phase.animation
                    }
                Spacer()
            }
            .padding()
            .onAppear {
                
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var appwrite = Appwrite()
    SplashContent(user: appwrite)
}

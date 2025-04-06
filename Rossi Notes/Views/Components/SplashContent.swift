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
        case .beginning: 0.5
        case .middle: 1.0
        case .end: 0.5
        }
    }
    
    var scale: Double {
        switch self {
        case .beginning, .end: 0.8
        case .middle: 1.1
        }
    }
    
    var animation: Animation {
        switch self {
        case .beginning, .end: .bouncy(duration: 0.75)
        case .middle: .easeInOut(duration: 1.5)
        }
    }
}

struct SplashContent: View {
        @State private var shouldDisplaySplashView = true
    
    var body: some View {
        ZStack {
            MainBackgroundView()
            VStack {
                Text("Rossi Notes")
                    .font(Font.custom("ConcertOne-Regular", size: 34))
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
                Text("A way to easily share dog walking protocol information")
                    .font(Font.custom("Urbanist-Medium", size: 20))
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding()
        }
    }
}

//#Preview {
//    @Previewable @StateObject var appwrite = Appwrite()
//    SplashContent(user: appwrite)
//}

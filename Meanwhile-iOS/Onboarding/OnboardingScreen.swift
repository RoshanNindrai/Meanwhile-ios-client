import Foundation
import SwiftUI
import WorkflowSwiftUI

struct OnboardingScreen: ObservableScreen {
    let model: OnboardingScreenModel

    static func makeView(store: Store<OnboardingScreenModel>) -> some View {
        OnboardingView(store: store)
    }
}

struct OnboardingView: View {
    
    @Bindable var store: Store<OnboardingScreenModel>
    
    var body: some View {
        VStack {
            Text("Onboarding")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 24)
        }.containerRelativeFrame(
            [.horizontal, .vertical]
        ).background(Color(.systemBackground))
    }
}

#Preview {
    OnboardingWorkflow()
        .ignoringOutput()
        .workflowPreview()
}

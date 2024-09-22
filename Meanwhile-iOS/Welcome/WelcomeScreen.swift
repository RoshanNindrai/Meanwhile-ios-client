import Foundation
import SwiftUI
import ViewEnvironment
import Workflow
import WorkflowSwiftUI

struct WelcomeScreen: ObservableScreen {
    let model: WelcomeScreenModel

    static func makeView(store: Store<WelcomeScreenModel>) -> some View {
        WelcomeView(store: store)
    }
}

struct WelcomeView: View {
    
    @Bindable var store: Store<WelcomeScreenModel>
    
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to Meanwhile")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 24)
            
            Text("Read our Privacy Policy. Tap \"Agree & Continue\" to accept the Terms of Service.")
                .font(.caption)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 64)
            
            Button(action: {
                store.actionSink.send(.didAgreeToTermsAndCondition)
            }) {
                Text("Agree & Continue")
                    .fontWeight(.bold)
                    .font(.headline)
                    .fontDesign(.rounded)
                    .padding()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }.containerRelativeFrame(
            [.horizontal, .vertical]
        )
    }
}

#Preview {
    WelcomeWorkflow()
        .workflowPreview()
}

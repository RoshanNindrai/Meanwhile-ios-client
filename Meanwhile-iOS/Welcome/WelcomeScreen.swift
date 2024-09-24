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
            Text(LocalizedStringKey("Welcome_to_Meanwhile"))
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 24)
            
            Text(LocalizedStringKey("Read_our_Privacy_Policy_Tap_\"Agree_&_Continue\"_to_accept_the_Terms_of_Service"))
                .font(.caption)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 64)
            
            Button(action: {
                store.actionSink.send(.didAgreeToTermsAndCondition)
            }) {
                Text(LocalizedStringKey("Agree_&_Continue"))
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
    WelcomeWorkflow(dependencyContainer: AppDependencyContainer(application: .shared))
        .workflowPreview()
}

import Foundation
import iPhoneNumberField
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
    @State var phoneNumber: String = .init()
    @FocusState var isEditingPhoneNumber: Bool
    
    var body: some View {
        NavigationStack{
            VStack {
                Text(LocalizedStringKey("Meanwhile_will_need_to_verify_your_account__Carrier_charges_may_apply_"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontWeight(.bold)
                    .padding(.bottom, 24)
                    .padding(.horizontal, 24)
                
                            
                iPhoneNumberField("Your phone number", text: $phoneNumber, formatted: false)
                    .flagHidden(false)
                    .flagSelectable(true)
                    .clearButtonMode(.whileEditing)
                    .onClear { _ in isEditingPhoneNumber.toggle() }
                    .focused($isEditingPhoneNumber)
                    .padding()
                    .cornerRadius(10)
                    .padding()
                
                Spacer()
                
                Button("Next") {
                    
                }

            }
        }.onAppear {
            triggerEditingMode()
        }.containerRelativeFrame(
            [.horizontal, .vertical]
        ).background(Color(.systemBackground))
    }
    
    private func triggerEditingMode() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isEditingPhoneNumber = true
        }
    }
}

#Preview {
    OnboardingWorkflow(dependencyContainer: .init(application: .shared))
        .ignoringOutput()
        .workflowPreview()
}

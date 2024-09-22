import Foundation
import Workflow
import WorkflowUI
import WorkflowSwiftUI

struct WelcomeWorkflow: Workflow {
    typealias Output = Never
}

// MARK: State

extension WelcomeWorkflow {
    @ObservableState
    enum State {
        case initialized
        case proceedToOnboarding
    }
    
    func makeInitialState() -> State {
        .initialized
    }
}

// MARK: - Action

extension WelcomeWorkflow {
    enum Action: WorkflowAction {
        typealias WorkflowType = WelcomeWorkflow
        
        case initialize
        case didAgreeToTermsAndCondition
        
        func apply(toState state: inout WelcomeWorkflow.State) -> WelcomeWorkflow.Output? {
            switch self {
            case .initialize:
                state = .initialized
            case .didAgreeToTermsAndCondition:
                state = .proceedToOnboarding
            }
            
            return nil
        }
    }
}

// MARK: - Rendering

extension WelcomeWorkflow {
    typealias Rendering = AnyScreen

    func render(state: State, context: RenderContext<WelcomeWorkflow>) -> Rendering {

        let actionSink = context.makeSink(of: Action.self)
        var childScreens: [NavigationBackStackContentScreen] = []
        
        switch state {
        case .initialized:
            break
        case .proceedToOnboarding:
            childScreens.append(
                OnboardingWorkflow()
                    .mapOutput { output -> Action in
                        switch output {
                        case .didTapBackButton:
                            return .initialize
                        }
                    }
                    .rendered(in: context)
                    .asBackStackContentScreen(
                        hideBackButton: true
                    )
                )
        }
        
        return WelcomeScreen(
            model: WelcomeScreenModel(
                accessor: context.makeStateAccessor(state: state),
                actionSink: actionSink,
                onboardingScreenModel: nil
            )
        )
        .asBackStack()
        .add(childScreens)
        .asAnyScreen()
    }
}

struct WelcomeScreenModel: ObservableModel {
    typealias State = WelcomeWorkflow.State
    
    let accessor: StateAccessor<State>
    let actionSink: Sink<WelcomeWorkflow.Action>
    let onboardingScreenModel: OnboardingScreenModel?
}

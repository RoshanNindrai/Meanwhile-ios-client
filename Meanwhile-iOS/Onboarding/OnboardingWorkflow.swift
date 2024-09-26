import Foundation
import Workflow
import WorkflowUI
import WorkflowSwiftUI

struct OnboardingWorkflow: Workflow {
    let dependencyContainer: AppDependencyContainer
}

// MARK: State

extension OnboardingWorkflow {
    @ObservableState
    struct State {
        enum ScreenState {
            case initialized
        }
        
        var screenState: ScreenState
        var deviceToken: String?
        var phoneNumber: String?
    }
    
    func makeInitialState() -> State {
        State(screenState: .initialized)
    }
}

// MARK: - Action

extension OnboardingWorkflow {
    enum Action: WorkflowAction {
        typealias WorkflowType = OnboardingWorkflow
        func apply(toState state: inout OnboardingWorkflow.State) -> OnboardingWorkflow.Output? {
            nil
        }
    }
}

// MARK: - Rendering

extension OnboardingWorkflow {
    typealias Rendering = AnyScreen

    func render(state: State, context: RenderContext<OnboardingWorkflow>) -> Rendering {
        
        switch state.screenState {
        case .initialized:
            context.runSideEffect(key: "RemoteNotificationRegistration") { lifetime in
                guard !lifetime.hasEnded else { return }
                dependencyContainer.notificationManger.requestNotificationPermission { deviceNotificationToken in
                    print(deviceNotificationToken)
                }
            }
        }
        
        return OnboardingScreen(
            model: OnboardingScreenModel(
                accessor: context.makeStateAccessor(state: state),
                actionSink: context.makeSink(of: Action.self)
            )
        ).asBackStack(
            key: "OnboardingWorkflow"
        )
        .asAnyScreen()
    }
}

struct OnboardingScreenModel: ObservableModel {
    typealias State = OnboardingWorkflow.State
    
    let accessor: StateAccessor<State>
    let actionSink: Sink<OnboardingWorkflow.Action>
}

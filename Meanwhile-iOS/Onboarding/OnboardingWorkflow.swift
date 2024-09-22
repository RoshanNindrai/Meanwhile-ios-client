import Foundation
import Workflow
import WorkflowUI
import WorkflowSwiftUI

struct OnboardingWorkflow: Workflow {
    enum Output {
        case didTapBackButton
    }
}

// MARK: State

extension OnboardingWorkflow {
    @ObservableState
    enum State {
        case initialized
    }
    
    func makeInitialState() -> State {
        .initialized
    }
}

// MARK: - Action

extension OnboardingWorkflow {
    enum Action: WorkflowAction {
        typealias WorkflowType = OnboardingWorkflow
        
        case tappedBackButton
        
        func apply(toState state: inout OnboardingWorkflow.State) -> OnboardingWorkflow.Output? {
            switch self {
            case .tappedBackButton:
                return .didTapBackButton
            }
        }
    }
}

// MARK: - Rendering

extension OnboardingWorkflow {
    typealias Rendering = AnyScreen

    func render(state: State, context: RenderContext<OnboardingWorkflow>) -> Rendering {
        
        switch state {
        case .initialized:
            break
        }
        
        return OnboardingScreen(
            model: OnboardingScreenModel(
                accessor: context.makeStateAccessor(state: state),
                actionSink: context.makeSink(of: Action.self)
            )
        ).asAnyScreen()
    }
}

struct OnboardingScreenModel: ObservableModel {
    typealias State = OnboardingWorkflow.State
    
    let accessor: StateAccessor<State>
    let actionSink: Sink<OnboardingWorkflow.Action>
}

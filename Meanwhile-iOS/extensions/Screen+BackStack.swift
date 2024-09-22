import Foundation
import UIKit
import SwiftUI
import Workflow
import WorkflowUI

struct NavigationItem {
    let title: String?
    let hideNavigationBar: Bool
    let hideBackButton: Bool
    
    init(
        title: String? = nil, 
        hideNavigationBar: Bool = false,
        hideBackButton: Bool = false
    ) {
        self.title = title
        self.hideNavigationBar = hideNavigationBar
        self.hideBackButton = hideBackButton
    }
}

protocol NavigationBackStackContentScreen: Screen {
    func navigationItem() -> NavigationItem
}

struct NavigationBackStackContentScreenImpl: Screen {
    let screen: Screen
    let navItem: NavigationItem
    
    func viewControllerDescription(environment: ViewEnvironment) -> ViewControllerDescription {
        screen.viewControllerDescription(environment: environment)
    }
}

extension NavigationBackStackContentScreenImpl: NavigationBackStackContentScreen {
    func navigationItem() -> NavigationItem {
        navItem
    }
}

protocol NavigationBackStack: Screen {
    func add(_ screens: [NavigationBackStackContentScreen]) -> Self
}

extension Screen {
    func asBackStack<Key: Hashable>(key: Key) -> NavigationBackStack {
        NavigationBackStackScreen(base: self, key: key)
    }
    
    func asBackStack() -> NavigationBackStack {
        NavigationBackStackScreen(base: self, key: AnyHashable(ObjectIdentifier(Self.Type.self)))
    }
    
    func asBackStackContentScreen(
        title: String? = nil,
        hideNavigationBar: Bool = false,
        hideBackButton: Bool = false
    ) -> NavigationBackStackContentScreen {
        NavigationBackStackContentScreenImpl(
            screen: self,
            navItem: .init(
                title: title,
                hideNavigationBar: hideNavigationBar, 
                hideBackButton: hideBackButton
            )
        )
    }
}

struct NavigationBackStackScreen: NavigationBackStack {
    let baseScreen: AnyScreen
    let key: AnyHashable
    var childScreens: [NavigationBackStackContentScreen]

    init<ScreenType: Screen, Key: Hashable>(base screen: ScreenType, key: Key?, childScreens: [NavigationBackStackContentScreen] = []) {
        self.baseScreen = AnyScreen(screen)
        self.childScreens = childScreens
        if let key = key {
            self.key = AnyHashable(key)
        } else {
            self.key = AnyHashable(ObjectIdentifier(ScreenType.self))
        }
    }

    init<ScreenType: Screen>(base screen: ScreenType) {
        let key = Optional<AnyHashable>.none
        self.init(base: screen, key: key)
    }

    fileprivate func isEquivalent(to otherScreen: NavigationBackStackScreen) -> Bool {
        return key == otherScreen.key
    }

    func viewControllerDescription(environment: ViewEnvironment) -> ViewControllerDescription {
        return BackStackContainerViewController.description(for: self, environment: environment)
    }
    
    func add(_ screens: [NavigationBackStackContentScreen]) -> Self {
        NavigationBackStackScreen(
            base: baseScreen,
            key: key,
            childScreens: childScreens + screens
        )
    }
}

private final class BackStackContainerViewController: ScreenViewController<NavigationBackStackScreen> {
    var rootViewController: DescribedViewController
    let navController: UINavigationController

    required init(screen: NavigationBackStackScreen, environment: ViewEnvironment) {
        rootViewController = DescribedViewController(screen: screen.baseScreen, environment: environment)
        navController = UINavigationController(rootViewController: rootViewController)
        super.init(screen: screen, environment: environment)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(navController)
        view.addSubview(navController.view)
        navController.didMove(toParent: self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navController.view.frame = view.bounds
    }

    override func screenDidChange(from previousScreen: NavigationBackStackScreen, previousEnvironment: ViewEnvironment) {
        super.screenDidChange(from: previousScreen, previousEnvironment: previousEnvironment)
        rootViewController.update(screen: screen.baseScreen, environment: environment)

        let childViewControllers = screen.childScreens.map { childScreen in
            let navigationItemInfo = childScreen.navigationItem()
            let childSCreenVC = DescribedViewController(screen: childScreen, environment: environment)
            childSCreenVC.navigationItem.title = navigationItemInfo.title
            childSCreenVC.navigationItem.hidesBackButton = navigationItemInfo.hideBackButton
            childSCreenVC.navigationController?.setNavigationBarHidden(navigationItemInfo.hideNavigationBar, animated: true)
            return childSCreenVC
        }
        
        let viewControllers = [rootViewController] + childViewControllers
        navController.setViewControllers(viewControllers, animated: true)
    }
}

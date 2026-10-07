import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        tabBarController.tabBar.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)

        // Home Tab
        let homeViewController = MainListViewController()
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)

        // Calendar Tab
        let calendarViewController = CalendarViewController()
        let calendarNavController = UINavigationController(rootViewController: calendarViewController)
        calendarNavController.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 1)

        // Settings Tab
        let settingsViewController = SettingsViewController()
        let settingsNavController = UINavigationController(rootViewController: settingsViewController)
        settingsNavController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)

        tabBarController.viewControllers = [homeNavController, calendarNavController, settingsNavController]

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

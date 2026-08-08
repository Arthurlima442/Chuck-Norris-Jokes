import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        /// Cria o service compartilhado
        let service = JokeService()
        
        /// Tela 1: Piadas
        let jokeViewModel = JokeViewModel(service: service)
        let jokeViewController = JokeViewController(viewModel: jokeViewModel)
        let jokeNavController = UINavigationController(rootViewController: jokeViewController)
        jokeNavController.tabBarItem = UITabBarItem(
            title: "Piadas",
            image: UIImage(systemName: "laugh"),
            tag: 0
        )
        
        /// Tela 2: Categorias
        let categoriesViewModel = CategoriesViewModel(service: service)
        let categoriesViewController = CategoriesViewController(viewModel: categoriesViewModel)
        let categoriesNavController = UINavigationController(rootViewController: categoriesViewController)
        categoriesNavController.tabBarItem = UITabBarItem(
            title: "Categorias",
            image: UIImage(systemName: "list.bullet"),
            tag: 1
        )
        
        /// Conectar delegate para quando categoria for selecionada
        categoriesViewController.delegate = self
        
        /// TabBar Controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [jokeNavController, categoriesNavController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

// MARK: - CategoriesViewControllerDelegate

extension SceneDelegate: CategoriesViewControllerDelegate {
    /// Quando categoria é selecionada, mostra piada dessa categoria
    func didSelectCategory(_ category: String) {
        guard let tabBar = window?.rootViewController as? UITabBarController,
              let navController = tabBar.viewControllers?.first as? UINavigationController else { return }
        
        let service = JokeService()
        let viewModel = JokeViewModel(service: service)
        viewModel.loadJokeByCategory(category)
        
        let jokeViewController = JokeViewController(viewModel: viewModel)
        navController.pushViewController(jokeViewController, animated: true)
        tabBar.selectedIndex = 0
    }
}

//
//  TabBarController.swift
//  Chuck Norris Jokes
//
//  Created by Caio Fabrini on 08/08/26.
//

import UIKit

final class TabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabs()
    customizeTabBarAppearance()
  }

  private func setupTabs() {

    // Tela Piada
    let jokeViewModel = JokeViewModel(lastCategory: nil)
    let jokeViewController = JokeViewController(viewModel: jokeViewModel)

    // Tela Categoria
    let categoriesViewController = CategoriesViewController()

    // Navigation
    let jokeNav = UINavigationController(rootViewController: jokeViewController)
    let categoriesNav = UINavigationController(rootViewController: categoriesViewController)

    jokeNav.tabBarItem = UITabBarItem(
      title: "Piadas",
      image: UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate),
      selectedImage: UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysTemplate)
    )

    categoriesNav.tabBarItem = UITabBarItem(
      title: "Categorias",
      image: UIImage(systemName: "list.bullet")?.withRenderingMode(.alwaysTemplate),
      selectedImage: UIImage(systemName: "list.bullet")?.withRenderingMode(.alwaysTemplate)
    )

    viewControllers = [jokeNav, categoriesNav]
  }

  private func customizeTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundEffect = nil
    appearance.backgroundColor = .white
    appearance.shadowColor = .separator

    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = appearance
    tabBar.isTranslucent = false
    tabBar.itemPositioning = .fill
    tabBar.tintColor = .red
    tabBar.unselectedItemTintColor = .lightGray
  }
}

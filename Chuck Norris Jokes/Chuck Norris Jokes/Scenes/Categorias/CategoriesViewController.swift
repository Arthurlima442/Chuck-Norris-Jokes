//
//  CategoriesViewController.swift
//  Chuck Norris Jokes
//
//  Created by Arthur Lima on 07/08/26.
//
import UIKit

// MARK: - ViewController

class CategoriesViewController: UIViewController {
    
    // MARK: - Properties
    
    private let categoriesView = CategoriesView()
    private let viewModel = CategoriesViewModel()

    override func loadView() {
        view = categoriesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categorias"
        categoriesView.delegate = self
        
        /// Observer que atualiza tela quando estado muda
        viewModel.onStateChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        /// Carrega categorias assim que tela abre
        viewModel.loadCategories()
    }
    
    // MARK: - Update UI
    
    /// Atualiza a tela de acordo com estado do ViewModel
    private func updateUI() {
        switch viewModel.currentState {
        case .loading:
            categoriesView.loadingIndicator.isHidden = false
            categoriesView.loadingIndicator.startAnimating()
            categoriesView.tableView.isHidden = true
            
        case .success(let categories):
            categoriesView.loadingIndicator.stopAnimating()
            categoriesView.loadingIndicator.isHidden = true
            categoriesView.tableView.isHidden = false
            categoriesView.categories = categories
            
        case .error:
            categoriesView.loadingIndicator.stopAnimating()
            categoriesView.loadingIndicator.isHidden = true
            categoriesView.tableView.isHidden = true
        }
    }
}

// MARK: - CategoriesViewDelegate

extension CategoriesViewController: CategoriesViewDelegate {
    /// Quando categoria é selecionada
    func didSelectCategory(_ category: String) {
        let jokeViewModel = JokeViewModel(lastCategory: category)
        let jokeViewController = JokeViewController(viewModel: jokeViewModel)
        navigationController?.pushViewController(jokeViewController, animated: true)
    }
}

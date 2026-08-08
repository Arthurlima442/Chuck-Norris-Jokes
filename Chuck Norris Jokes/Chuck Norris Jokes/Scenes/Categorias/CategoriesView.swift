//
//  CategoriesView.swift
//  Chuck Norris Jokes
//
//  Created by Arthur Lima on 07/08/26.
//
import UIKit

// MARK: - Delegate

/// Notifica quando uma categoria é selecionada
protocol CategoriesViewDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}

// MARK: - View

/// Exibe lista de categorias em uma TableView
class CategoriesView: UIView {
    
    // MARK: - Delegate
    
    weak var delegate: CategoriesViewDelegate?
    
    // MARK: - UI Components
    
    /// TableView que exibe as categorias
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    /// Spinner de carregamento
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Properties
    
    /// Array de categorias que atualiza a tableView automaticamente
    var categories: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewHierarchy()
        configConstraints()
        setupBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Hierarchy
    
    /// Adiciona tableView e loading indicator à tela
    private func buildViewHierarchy() {
        addSubview(tableView)
        addSubview(loadingIndicator)
    }
    
    // MARK: - Setup Methods
    
    /// Define cores de fundo
    private func setupBackgroundColor() {
        backgroundColor = .systemBackground

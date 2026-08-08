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
        tableView.backgroundColor = .systemBackground
    }

    // MARK: - Constraints

    /// Define posição e tamanho dos componentes
    private func configConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension CategoriesView: UITableViewDataSource {
    /// Retorna quantidade de categorias
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    /// Cria célula com nome da categoria
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoriesView: UITableViewDelegate {
    /// Notifica quando categoria é selecionada
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        delegate?.didSelectCategory(category)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

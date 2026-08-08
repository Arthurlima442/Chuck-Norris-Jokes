//
//  CategoriesViewModel.swift
//  Chuck Norris Jokes
//
//  Created by Arthur Lima on 07/08/26.
//
import Foundation

// MARK: - View State

enum CategoriesViewState {
    case loading
    case success(categories: [String])
    case error(message: String)
}

// MARK: - ViewModel

class CategoriesViewModel {
    
    // MARK: - Properties
    
    /// Service para buscar categorias
    private let service: JokeServiceProtocol = JokeService()

    /// Estado atual que avisa quando muda
    private(set) var currentState: CategoriesViewState = .loading {
        didSet {
            onStateChanged?()
        }
    }
    
    /// Closure chamado quando estado muda
    var onStateChanged: (() -> Void)?
    
    // MARK: - Public Methods
    
    /// Carrega lista de categorias da API
    func loadCategories() {
        currentState = .loading
        
        service.fetchCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.currentState = .success(categories: categories)
            case .failure(let error):
                let message = self?.errorMessage(for: error) ?? "Erro desconhecido"
                self?.currentState = .error(message: message)
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Converte erro técnico em mensagem amigável
    private func errorMessage(for error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "URL inválida"
        case .noData:
            return "Nenhum dado recebido"
        case .decodingError:
            return "Erro ao processar resposta"
        case .httpError(let statusCode):
            return "Erro HTTP \(statusCode)"
        case .unknownError:
            return "Erro de conexão"
        }
    }
}

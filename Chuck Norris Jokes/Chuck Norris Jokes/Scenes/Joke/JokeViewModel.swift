//
//  JokeViewModel.swift
//  Chuck Norris Jokes
//
//  Created by Arthur Lima on 07/08/26.
//
import Foundation

// MARK: - View State

enum ViewState {
  case loading
  case success(joke: Joke)
  case error(message: String)
}

// MARK: - ViewModel

class JokeViewModel {

  // MARK: - Properties

  private let service: JokeServiceProtocol = JokeService()

  private(set) var currentState: ViewState = .loading {
    didSet {
      onStateChanged?()
    }
  }

  var onStateChanged: (() -> Void)?

  private var lastCategory: String?

  // MARK: - Lifecycle

  init(lastCategory: String?) {
    self.lastCategory = lastCategory
  }

  // MARK: - Public Methods

  /// Carrega uma piada aleatória da API
  private func loadRandomJoke() {
    currentState = .loading
    service.fetchRandomJoke { [weak self] result in
      switch result {
      case .success(let joke):
        self?.currentState = .success(joke: joke)
      case .failure(let error):
        let message = self?.errorMessage(for: error) ?? "Erro desconhecido"
        self?.currentState = .error(message: message)
      }
    }
  }

  /// Carrega uma piada de uma categoria específica
  private func loadJokeByCategory() {
    currentState = .loading
    service.fetchJokeByCategory(lastCategory ?? "") { [weak self] result in
      switch result {
      case .success(let joke):
        self?.currentState = .success(joke: joke)
      case .failure(let error):
        let message = self?.errorMessage(for: error) ?? "Erro desconhecido"
        self?.currentState = .error(message: message)
      }
    }
  }

  /// Tenta novamente a última requisição (categoria ou aleatória)
  func fetchJoke() {
    if lastCategory != nil {
      loadJokeByCategory()
    } else {
      loadRandomJoke()
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

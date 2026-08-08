//
//  JokeService.swift
//  Chuck Norris Jokes
//
//  Created by Arthur Lima on 07/08/26.
//
import Foundation

// MARK: - Network Error

/// Tipos de erro que podem acontecer ao fazer requisição
enum NetworkError: Error {
    /// URL malformada
    case invalidURL
    /// API não devolveu dados
    case noData
    /// JSON não conseguiu ser convertido
    case decodingError
    /// Erro HTTP (404, 500, etc)
    case httpError(statusCode: Int)
    /// Outros erros de conexão
    case unknownError(Error)
}

// MARK: - Protocol

/// Define quais funções o service deve ter
protocol JokeServiceProtocol {
    /// Busca uma piada aleatória
    func fetchRandomJoke(completion: @escaping (Result<Joke, NetworkError>) -> Void)
    /// Busca uma piada de uma categoria específica
    func fetchJokeByCategory(_ category: String, completion: @escaping (Result<Joke, NetworkError>) -> Void)
    /// Busca todas as categorias disponíveis
    func fetchCategories(completion: @escaping (Result<[String], NetworkError>) -> Void)
}

// MARK: - Service Implementation

class JokeService: JokeServiceProtocol {
    
    // MARK: - Properties
    
    /// URL base da API
    private let baseURL = "https://api.chucknorris.io"
    
    // MARK: - Public Methods
    
    /// Busca uma piada aleatória da API
    func fetchRandomJoke(completion: @escaping (Result<Joke, NetworkError>) -> Void) {
        let urlString = "\(baseURL)/jokes/random"
        performRequest(urlString: urlString, completion: completion)
    }
    
    /// Busca uma piada de uma categoria específica
    func fetchJokeByCategory(_ category: String, completion: @escaping (Result<Joke, NetworkError>) -> Void) {
        let urlString = "\(baseURL)/jokes/random?category=\(category)"
        performRequest(urlString: urlString, completion: completion)
    }
    
    /// Busca todas as categorias disponíveis
    func fetchCategories(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        let urlString = "\(baseURL)/jokes/categories"
        performRequest(urlString: urlString, completion: completion)
    }
    
    // MARK: - Private Methods
    
    /// Faz requisição HTTP genérica e converte JSON em tipo T
    private func performRequest<T: Decodable>(
        urlString: String,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.httpError(statusCode: httpResponse.statusCode)))
                    return
                }
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedObject = try decoder.decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

//
//  Joke.swift
//  Chuck Norris Jokes
//
//  Created by Arthur Lima on 07/08/26.
//
import Foundation

// MARK: - Model

/// Estrutura que representa uma piada da API
struct Joke: Decodable {
    
    // MARK: - Properties
    
    /// Identificador único da piada
    let id: String
    
    /// Texto da piada
    let value: String
    
    /// URL da imagem/ícone do Chuck Norris
    let iconUrl: String
    
    /// URL da piada no site
    let url: String
    
    /// Data de criação
    let createdAt: String
    
    /// Data de atualização
    let updatedAt: String
    
    /// Categorias relacionadas
    let categories: [String]
    
    // MARK: - Coding Keys
    
    /// Mapeia chaves JSON (snake_case) para propriedades Swift (camelCase)
    enum CodingKeys: String, CodingKey {
        case id
        case value
        case iconUrl = "icon_url"
        case url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categories
    }
}

// MARK: - Extensions

extension Joke {
    
    /// Converte a string iconUrl em um objeto URL para carregar a imagem
    var imageURL: URL? {
        return URL(string: iconUrl)
    }
}

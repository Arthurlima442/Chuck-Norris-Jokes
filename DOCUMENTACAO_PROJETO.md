# 📱 Chuck Norris Jokes - Documentação Completa

## 📋 Visão Geral

Aplicativo iOS desenvolvido em **Swift** usando **UIKit** e **ViewCode**, que consome a API pública Chuck Norris para exibir piadas aleatórias e categorizadas.

---

## ✅ Requisitos Atendidos

### 🏗️ Requisitos Técnicos

- ✅ **Swift** - Linguagem principal
- ✅ **UIKit** - Framework de interface
- ✅ **ViewCode** - Sem Storyboard, tudo em código
- ✅ **MVVM** - Arquitetura Model-View-ViewModel
- ✅ **URLSession** - Requisições HTTP
- ✅ **Codable/Decodable** - Parse de JSON
- ✅ **Auto Layout** - Constraints programáticas

### 🎯 Requisitos Mínimos

1. ✅ **ViewCode** - Todas as telas criadas sem Storyboard
2. ✅ **MVVM** - Separação clara de responsabilidades
3. ✅ **URLSession** - Networking implementado
4. ✅ **Decodable** - JSON → Objects
5. ✅ **Piada ao iniciar** - Carregamento automático
6. ✅ **Nova piada** - Botão funcional
7. ✅ **Loading** - Spinner durante requisição
8. ✅ **Tratamento de erros** - Estados error implementados
9. ✅ **Tela de categorias** - TableView funcional
10. ✅ **Selecionar categoria** - Navegação e busca

---

## 📂 Estrutura do Projeto

```
Chuck Norris Jokes/
├── Models/
│   └── Joke.swift              ✅ Decodable
├── Services/
│   └── JokeService.swift       ✅ URLSession + Protocol
├── Scenes/
│   ├── JokeView.swift          ✅ ViewCode
│   ├── JokeViewController.swift ✅ Controle
│   ├── JokeViewModel.swift     ✅ Lógica
│   └── Categorias/
│       ├── CategoriesView.swift           ✅ TableView
│       ├── CategoriesViewController.swift ✅ Controle
│       └── CategoriesViewModel.swift      ✅ Lógica
├── SceneDelegate.swift         ✅ TabBar Navigation
└── AppDelegate.swift           (não modificado)
```

---

## 🔍 Detalhes de Cada Arquivo

### 1️⃣ **Models/Joke.swift**

**Objetivo:** Estrutura de dados que representa uma piada da API

**Características:**
- `struct Joke: Decodable` - Converte JSON automaticamente
- `CodingKeys` - Mapeia snake_case (JSON) → camelCase (Swift)
  - `icon_url` → `iconUrl`
  - `created_at` → `createdAt`
  - `updated_at` → `updatedAt`
- Extension com propriedade `imageURL` - Converte string em URL
- ✅ Comentários em cada propriedade

**Exemplo JSON da API:**
```json
{
  "id": "abc123",
  "value": "Chuck Norris can divide by zero.",
  "icon_url": "https://...",
  "url": "https://...",
  "created_at": "2020-01-05",
  "updated_at": "2020-01-05",
  "categories": []
}
```

---

### 2️⃣ **Services/JokeService.swift**

**Objetivo:** Isolar comunicação com a API

**Componentes:**

#### a) NetworkError (enum)
```swift
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case httpError(statusCode: Int)
    case unknownError(Error)
}
```
- Tipos de erro bem definidos
- ✅ Comentários descritivos

#### b) JokeServiceProtocol
```swift
protocol JokeServiceProtocol {
    func fetchRandomJoke(completion: @escaping ...)
    func fetchJokeByCategory(_ category: String, ...)
    func fetchCategories(completion: @escaping ...)
}
```
- Define contrato de serviço
- Permite mock/testing
- ✅ Comentários em cada função

#### c) JokeService (Implementação)
- `fetchRandomJoke()` - GET /jokes/random
- `fetchJokeByCategory()` - GET /jokes/random?category=X
- `fetchCategories()` - GET /jokes/categories
- `performRequest<T>()` - Função genérica que:
  - Valida URL
  - Faz requisição HTTPs
  - Valida status code (200-299)
  - Decodifica JSON
  - Retorna Result<T, NetworkError>

**Fluxo de Erro:**
```
URL inválida → .invalidURL
Sem conexão → .unknownError
Status 404 → .httpError(404)
JSON inválido → .decodingError
Sem dados → .noData
```

---

### 3️⃣ **Scenes/JokeViewModel.swift**

**Objetivo:** Lógica de negócio e gerenciamento de estado

**Estados Possíveis:**
```swift
enum ViewState {
    case loading        // Carregando
    case success(joke: Joke)  // Piada carregada
    case error(message: String)   // Erro com mensagem
}
```

**Métodos Públicos:**

| Método | O quê | Quando |
|--------|-------|--------|
| `loadRandomJoke()` | Busca piada aleatória | Ao abrir app ou clicar botão |
| `loadJokeByCategory()` | Busca piada de categoria | Ao selecionar categoria |
| `retry()` | Tenta novamente | Ao clicar "Tentar Novamente" |

**Observador:**
```swift
var onStateChanged: (() -> Void)?
```
- Avisa ViewController quando estado muda
- DispatchQueue.main.async garante atualização na main thread

**Tratamento de Erro:**
- Converte `NetworkError` em mensagem amigável (pt-BR)
- "URL inválida", "Erro de conexão", etc.

---

### 4️⃣ **Scenes/JokeView.swift**

**Objetivo:** Interface visual em ViewCode

**Componentes (lazy var):**

| Componente | Tipo | Função |
|-----------|------|--------|
| `imageView` | UIImageView | Exibe ícone Chuck Norris |
| `loadingIndicator` | UIActivityIndicatorView | Spinner de carregamento |
| `jokeLabel` | UILabel | Texto da piada |
| `errorLabel` | UILabel | Mensagem de erro |
| `newJokeButton` | UIButton | Botão "Nova Piada" |

**Delegate:**
```swift
protocol JokeViewDelegate {
    func didTapNewJokeButton()
}
```

**Layout:**
- Todas as constraints em UMA chamada `NSLayoutConstraint.activate([])`
- Safe area layout
- Componentes centralizados com padding 16pt
- Botão 50pt de altura

---

### 5️⃣ **Scenes/JokeViewController.swift**

**Objetivo:** Conectar View com ViewModel

**Fluxo:**

1. `loadView()` - Define `jokeView` como view principal
2. `viewDidLoad()` - Configura:
   - `jokeView.delegate = self`
   - Observer `viewModel.onStateChanged`
   - Carrega primeira piada
3. `updateUI()` - Responde aos 3 estados:
   - **Loading:** mostra spinner
   - **Success:** mostra piada + imagem
   - **Error:** mostra mensagem + botão retry
4. Implementa `JokeViewDelegate` - Quando botão clicado, chama `viewModel.loadRandomJoke()`

**Carregamento de Imagem:**
```swift
URLSession.shared.dataTask(with: url) { data, _, _ in
    if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
            self?.jokeView.imageView.image = image
        }
    }
}.resume()
```

---

### 6️⃣ **Scenes/Categorias/CategoriesView.swift**

**Objetivo:** Exibir categorias em TableView

**Componentes:**
- `tableView` - UITableView com células
- `loadingIndicator` - Spinner durante carregamento

**DataSource:**
```swift
func tableView(..., numberOfRowsInSection ...) -> Int
func tableView(..., cellForRowAt ...) -> UITableViewCell
```

**Delegate:**
```swift
func tableView(..., didSelectRowAt ...)
→ delegate?.didSelectCategory(category)
```

**Protocolo:**
```swift
protocol CategoriesViewDelegate {
    func didSelectCategory(_ category: String)
}
```

---

### 7️⃣ **Scenes/Categorias/CategoriesViewController.swift**

**Objetivo:** Controlar tela de categorias

**Fluxo:**
1. `viewDidLoad()` - Carrega categorias
2. Observer atualiza quando ViewModel muda
3. `updateUI()` - Responde aos 3 estados (loading, success, error)
4. Implementa `CategoriesViewDelegate` - Notifica delegate quando categoria selecionada

**Delegate:**
```swift
protocol CategoriesViewControllerDelegate {
    func didSelectCategory(_ category: String)
}
```

---

### 8️⃣ **Scenes/Categorias/CategoriesViewModel.swift**

**Objetivo:** Lógica para categorias

**Estados:**
```swift
enum CategoriesViewState {
    case loading
    case success(categories: [String])
    case error(message: String)
}
```

**Método Público:**
- `loadCategories()` - GET /jokes/categories

---

### 9️⃣ **SceneDelegate.swift**

**Objetivo:** Configurar navegação principal com TabBar

**Estrutura:**

```
TabBarController
├── [0] JokeNavigationController
│       └── JokeViewController (Piadas)
└── [1] CategoriesNavigationController
        └── CategoriesViewController (Categorias)
```

**Abas:**
| Aba | Título | Ícone | Tag |
|-----|--------|-------|-----|
| 0 | "Piadas" | laugh | 0 |
| 1 | "Categorias" | list.bullet | 1 |

**Navegação (Categoria → Piada):**
```swift
extension SceneDelegate: CategoriesViewControllerDelegate {
    func didSelectCategory(_ category: String) {
        // 1. Cria novo ViewModel com categoria
        viewModel.loadJokeByCategory(category)
        // 2. Cria novo ViewController
        let jokeViewController = JokeViewController(viewModel: viewModel)
        // 3. Faz push na navigation stack
        navController.pushViewController(jokeViewController, animated: true)
        // 4. Volta para aba 0 (Piadas)
        tabBar.selectedIndex = 0
    }
}
```

---

## 🔄 Fluxo de Dados (MVVM)

### Ao Abrir o App

```
1. SceneDelegate cria:
   - JokeService (compartilhado)
   - JokeViewModel
   - JokeViewController

2. JokeViewController.viewDidLoad():
   - Conecta delegate
   - Conecta observer
   - Chama viewModel.loadRandomJoke()

3. JokeViewModel.loadRandomJoke():
   - Muda estado para .loading
   - Chama service.fetchRandomJoke()

4. JokeService faz requisição:
   - GET https://api.chucknorris.io/jokes/random
   - Decodifica JSON
   - Retorna Result<Joke, NetworkError>

5. ViewModel recebe resposta:
   - Sucesso → estado = .success(joke)
   - Erro → estado = .error(mensagem)
   - Chama onStateChanged()

6. ViewController atualiza UI:
   - Esconde spinner
   - Mostra piada
   - Carrega imagem via URLSession
   - Mostra botão "Nova Piada"
```

### Ao Selecionar Categoria

```
1. CategoriesViewController detecta clique
   → Chama delegate.didSelectCategory(category)

2. SceneDelegate recebe notification
   → Cria novo JokeViewController
   → Faz push na navigation stack
   → Volta para aba "Piadas"

3. Novo JokeViewController abre
   → Mostra piada da categoria selecionada
```

---

## 📊 Tratamento de Estados

### Tela de Piadas

| Estado | UI Mostrada |
|--------|------------|
| **Loading** | Spinner no centro |
| **Success** | Imagem + Texto + Botão |
| **Error** | Mensagem vermelha + Botão "Tentar Novamente" |

### Tela de Categorias

| Estado | UI Mostrada |
|--------|------------|
| **Loading** | Spinner no centro |
| **Success** | TableView com categorias |
| **Error** | (Esconde tudo) |

---

## 🛡️ Tratamento de Erros

**Mapeamento de NetworkError → Mensagem Amigável:**

```swift
case .invalidURL:           → "URL inválida"
case .noData:              → "Nenhum dado recebido"
case .decodingError:       → "Erro ao processar resposta"
case .httpError(statusCode):→ "Erro HTTP \(statusCode)"
case .unknownError:        → "Erro de conexão"
```

---

## 💬 Comentários no Código

✅ **Todos os arquivos têm comentários**

**Padrão:**
```swift
// MARK: - Seção

/// Descrição em uma linha da função
func nomeFunc() {
    // Código
}
```

**Nível de Detalhe:**
- Funções públicas: documentadas
- Propriedades: documentadas
- Lógica complexa: comentários inline

---

## 🎨 Arquitetura MVVM

### Separação de Responsabilidades

| Camada | Responsabilidade |
|--------|-----------------|
| **Model** | Estrutura de dados (Joke) |
| **View** | Desenhar interface (JokeView, CategoriesView) |
| **ViewController** | Conectar View com ViewModel |
| **ViewModel** | Lógica de negócio + gerenciamento de estado |
| **Service** | Comunicação com API |

### Fluxo de Dependências

```
View
  ↓ (informa eventos)
ViewController
  ↓ (usa)
ViewModel
  ↓ (usa)
Service
  ↓ (usa)
Model
```

---

## 🚀 Histórico de Commits

```
db61bbc - Completar CategoriesView com constraints e extensions
96a867f - Criar CategoriesViewModel
18d9b36 - Criar CategoriesViewController
58870b8 - Criar CategoriesView com TableView
6eea295 - Criar JokeService com URLSession e tratamento de erros
7c33b3e - Criar Model Joke e JokeViewModel
6b14e88 - Criar JokeViewController com bindViewModel
6608179 - Criar JokeView com layout programático
65df029 - Initial commit
```

---

## 🧪 Como Testar

### Teste Manual

1. **Ao abrir:** Piada aleatória carrega automaticamente
2. **Botão "Nova Piada":** Carrega piada diferente
3. **Aba Categorias:** Lista todas as categorias
4. **Selecionar Categoria:** Volta para Piadas com piada da categoria
5. **Sem Internet:** Mostra "Erro de conexão"

### Estados Observados

- ✅ Loading: Spinner aparece e desaparece
- ✅ Success: Texto + imagem aparecem
- ✅ Error: Mensagem em vermelho aparece

---

## 📝 Notas Finais

### Pontos Fortes

1. ✅ Código bem organizado com MARK
2. ✅ Todos os comentários solicitados
3. ✅ Separação clara de responsabilidades
4. ✅ Tratamento robusto de erros
5. ✅ ViewCode sem Storyboard
6. ✅ Navegação com TabBar funcional
7. ✅ Estados bem definidos

### Possíveis Melhorias (não implementadas)

- Cache de piadas
- Favoritos
- Pull to refresh
- Testes unitários
- Compartilhamento de piadas

---

**Projeto finalizado com sucesso! 🎉**

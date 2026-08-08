import UIKit

class JokeViewController: UIViewController {

  let jokeView = JokeView()
  let viewModel: JokeViewModel

  init(viewModel: JokeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = jokeView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configView()
    fetchRequest()
  }

  func configView() {
    jokeView.delegate = self

//    jokeView.onTapNewJokeButton = { [weak self] in
//      self?.viewModel.loadRandomJoke()
//    }
  }

  func fetchRequest() {
    viewModel.onStateChanged = { [weak self] in
      DispatchQueue.main.async {
        self?.updateUI()
      }
    }

    viewModel.fetchJoke()
  }

  func updateUI() {
    switch viewModel.currentState {
    case .loading:
      jokeView.loadingIndicator.isHidden = false
      jokeView.loadingIndicator.startAnimating()
      jokeView.jokeLabel.isHidden = true
      jokeView.errorLabel.isHidden = true
      jokeView.imageView.isHidden = true
      jokeView.newJokeButton.isHidden = true

    case .success(let joke):
      jokeView.loadingIndicator.isHidden = true
      jokeView.jokeLabel.isHidden = false
      jokeView.errorLabel.isHidden = true
      jokeView.imageView.isHidden = false
      jokeView.newJokeButton.isHidden = false
      jokeView.jokeLabel.text = joke.value

      if let url = joke.imageURL {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
          if let data = data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
              self?.jokeView.imageView.image = image
            }
          }
        }.resume()
      }

    case .error(let message):
      jokeView.loadingIndicator.isHidden = true
      jokeView.jokeLabel.isHidden = true
      jokeView.errorLabel.isHidden = false
      jokeView.imageView.isHidden = true
      jokeView.newJokeButton.isHidden = false
      jokeView.errorLabel.text = message
    }
  }
}

extension JokeViewController: JokeViewDelegate {
  func didTapNewJokeButton() {
    viewModel.fetchJoke()
  }
}

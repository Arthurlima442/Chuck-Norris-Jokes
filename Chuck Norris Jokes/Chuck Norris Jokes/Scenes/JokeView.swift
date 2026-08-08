
import UIKit

protocol JokeViewDelegate: AnyObject {
    func didTapNewJokeButton()
}

class JokeView: UIView {
    
    // MARK: - Delegate
    weak var delegate: JokeViewDelegate?
    
    // MARK: - UI Components
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var jokeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var newJokeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Nova Piada", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapNewJokeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    private func buildViewHierarchy() {
        addSubview(imageView)
        addSubview(loadingIndicator)
        addSubview(jokeLabel)
        addSubview(errorLabel)
        addSubview(newJokeButton)
    }
    
    // MARK: - Setup Methods
    
    private func setupBackgroundColor() {
        backgroundColor = .systemBackground
    }
    
    // MARK: - Constraints
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            jokeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            jokeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            jokeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            errorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            newJokeButton.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor, constant: 30),
            newJokeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            newJokeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            newJokeButton.heightAnchor.constraint(equalToConstant: 50),
            newJokeButton.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapNewJokeButton() {
        delegate?.didTapNewJokeButton()
    }
}

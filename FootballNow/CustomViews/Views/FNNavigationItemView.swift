import UIKit

class FNNavigationItemView: UIView {

  let imageView = UIImageView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addSubviews() {
    addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "FNLogo")
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = false

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
      imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -5),
      imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
      imageView.widthAnchor.constraint(equalToConstant: 150)
    ])
  }

}

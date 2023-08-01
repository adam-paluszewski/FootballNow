import UIKit

class FNPlayerDetailsVC: UIViewController {

  let photoImageView = UIImageView()
  let nameLabel = FNLargeTitleLabel(allingment: .center)
  let positionLabel = FNLargeTitleLabel(allingment: .center)
  let tableView = UITableView()
  var playerNumber: Int?
  var playerPosition: String?
  var details: PlayerP!
  let titleForRow = ["Wiek", "Wzrost", "Waga", "Narodowość"]

  init(details: PlayerP?, number: Int?, position: String?) {
    super.init(nibName: nil, bundle: nil)
    self.playerNumber = number
    self.playerPosition = position
    self.details = details
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureTableView()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    preferredContentSize.height = tableView.contentSize.height + 260
  }

  func configureViewController() {
    NetworkManager.shared.downloadImage(from: details.photo ?? "", completionHandler: { [weak self] image in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.photoImageView.image = image
      }
    })
    nameLabel.text = (details.firstname ?? "") + " " + (details.lastname ?? "")
    positionLabel.text = FNTranslateToPolish.shared.translatePlayerPosition(from: playerPosition)
    positionLabel.textColor = .secondaryLabel
    photoImageView.clipsToBounds = true
    photoImageView.layer.cornerRadius = 75
    layoutUI()
  }

  func configureTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(FNPlayerDetailsCell.self, forCellReuseIdentifier: FNPlayerDetailsCell.cellId)
    tableView.separatorInset = UIElementsSizes.standardTableViewSeparatorInsets
    tableView.prepareForDynamicHeight()
  }

  func layoutUI() {
    view.addSubview(photoImageView)
    view.addSubview(nameLabel)
    view.addSubview(positionLabel)
    view.addSubview(tableView)

    photoImageView.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
      photoImageView.widthAnchor.constraint(equalToConstant: 150),
      photoImageView.heightAnchor.constraint(equalToConstant: 150),

      nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 15),
      nameLabel.heightAnchor.constraint(equalToConstant: 30),
      nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      positionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
      positionLabel.heightAnchor.constraint(equalToConstant: 20),

      tableView.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 20),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

}

extension FNPlayerDetailsVC: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titleForRow.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FNPlayerDetailsCell.cellId, for: indexPath) as! FNPlayerDetailsCell
    cell.set(player: details, row: indexPath.row, title: titleForRow[indexPath.row])
    return cell
  }

}

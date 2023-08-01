import UIKit

class LicensesVC: UIViewController {

  let textLabel = FNBodyLabel(allingment: .left)

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Licencje"
    view.backgroundColor = FNColors.sectionColor

    textLabel.numberOfLines = 0
    textLabel.text = """
 ICONS
 Icons used in this app were downloaded from:
 https://www.flaticon.com
 """
    view.addSubview(textLabel)

    NSLayoutConstraint.activate([
      textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
      textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
      textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
    ])
  }

}

import UIKit

extension UITableView {

  func prepareForDynamicHeight() {
    estimatedRowHeight = 0
    estimatedSectionHeaderHeight = 0
    estimatedSectionFooterHeight = 0
  }

  func reloadDataOnMainThread() {
    DispatchQueue.main.async {
      self.reloadData()
    }
  }

  func setEmptyMessage(text: String, image: EmptyStateImages, axis: UIAxis) {
    let emptyView = FNEmptyStateView(text: text, image: image, axis: axis)
    backgroundView = emptyView
    backgroundView?.addSubview(emptyView)

    NSLayoutConstraint.activate([
      emptyView.topAnchor.constraint(equalTo: backgroundView!.topAnchor),
      emptyView.leadingAnchor.constraint(equalTo: backgroundView!.leadingAnchor),
      emptyView.trailingAnchor.constraint(equalTo: backgroundView!.trailingAnchor),
      emptyView.bottomAnchor.constraint(equalTo: backgroundView!.bottomAnchor)
    ])
    self.separatorStyle = .none
  }

  func restore() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
  }

}

import UIKit

final class ViewController: UIViewController {

	let label = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))

	override func viewDidLoad() {
		super.viewDidLoad()
		print("isUITests>>>>>\(ProcessInfo.isUITests)")

		// пример изначально недоступного label, который можно сделать кнопкой
		self.label.accessibilityIdentifier = "label_button"
		self.label.accessibilityLabel = "Some text"
		self.label.isUserInteractionEnabled = true
		self.label.backgroundColor = .red
		self.label.center = self.view.center
		self.view.addSubview(self.label)

		if !ProcessInfo.isUITests {
			self.label.isAccessibilityElement = true
			self.label.accessibilityTraits = .button
		}

		let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tap))
		self.label.addGestureRecognizer(tapGR)

		self.navigationItem.rightBarButtonItems = [
			UIBarButtonItem(title: "VC3", style: .plain, target: self, action: #selector(self.showVC3)),
		]
	}

	@objc private func showVC3() {
		let vc = VC3(vm: VM3())
		self.navigationController?.pushViewController(vc, animated: true)
	}

	@objc private func tap() {
		print("On label tapped")
	}

}

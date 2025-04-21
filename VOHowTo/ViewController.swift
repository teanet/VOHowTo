import UIKit
import SwiftUI

final class ViewController: UIViewController {

	let label = UIView()

	override func viewDidLoad() {
		super.viewDidLoad()
		print("isUITests: \(ProcessInfo.isUITests)")

		// пример изначально недоступного label, который можно сделать кнопкой
		self.label.accessibilityIdentifier = "red_button"
		self.label.accessibilityLabel = "Red button"
		self.label.isUserInteractionEnabled = true
		self.label.backgroundColor = .red
		self.label.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
		self.view.addSubview(self.label)

		if !ProcessInfo.isUITests {
			self.label.isAccessibilityElement = true
			self.label.accessibilityTraits = .button
		}

		let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tap))
		self.label.addGestureRecognizer(tapGR)

		let childView = UIHostingController(rootView: SwiftUIView())
		addChild(childView)
		childView.view.frame = CGRect(x: 100, y: 170, width: 150, height: 50)
		self.view.addSubview(childView.view)
		childView.didMove(toParent: self)

		self.navigationItem.rightBarButtonItems = [
			UIBarButtonItem(title: "Stories", style: .plain, target: self, action: #selector(self.showVC3)),
			UIBarButtonItem(title: "Collection", style: .plain, target: self, action: #selector(self.showCollection)),
		]
	}

	@objc private func showVC3() {
		let vc = StoriesExampleVC(vm: StoriesExampleVM())
		self.navigationController?.pushViewController(vc, animated: true)
	}

	@objc private func showCollection() {
		let vc = CollectionVC(vm: StoriesExampleVM())
		self.navigationController?.pushViewController(vc, animated: true)
	}

	@objc private func tap() {
		print("On label tapped")
	}

}

struct SwiftUIView: View {
	var body: some View {
		Button {} label: {
			Image(systemName: "figure.walk")
		}
		.frame(width: 150, height: 50)
		.background(.green)
		.accessibilityLabel("SwiftUI green walk button")
	}
}

import UIKit

final class VC3: BaseVC<VM3> {

	private let label = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
	private let label2 = UILabel(frame: CGRect(x: 100, y: 200, width: 100, height: 100))

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
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

		self.label2.accessibilityIdentifier = "label2"
		self.label2.text = "Some other label"
		self.view.addSubview(self.label2)

		let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tap))
		self.label.addGestureRecognizer(tapGR)

		self.customAccessibilityElementsBlock = { [weak self] in
			/// если мы хотим вручную задать порядок элементов доступности, с учетом их видимости
			[self?.label, self?.label2]
		}
	}

	@objc private func tap() {
		print("On label tapped")
	}

}

import UIKit

typealias AccessibilityElementsBlock = () -> [Any?]?

class BaseView: UIView {
	/// Возможность переопределить текущую Accessibility иерархию задав блок для view снаружи
	var customAccessibilityElementsBlock: AccessibilityElementsBlock?

	override var accessibilityElements: [Any]? {
		get { self.customAccessibilityElementsBlock?()?.accessibilityElements() ?? super.accessibilityElements }
		set { super.accessibilityElements = newValue }
	}
}

class BaseVM: NSObject {
	override class func accessibilityPerformEscape() -> Bool {
		assertionFailure("Нужно реализовать")
		return false
	}
}

class BaseVC<T: BaseVM>: UIViewController {
	let vm: T

	/// Возможность переопределить текущую Accessibility иерархию задав блок для view снаружи
	var customAccessibilityElementsBlock: AccessibilityElementsBlock? {
		get { customView.customAccessibilityElementsBlock }
		set { customView.customAccessibilityElementsBlock = newValue }
	}
	private lazy var customView = BaseView(frame: UIScreen.main.bounds)

	init(vm: T) {
		self.vm = vm
		super.init(nibName: nil, bundle: nil)
	}

	override func loadView() {
		self.view = self.customView
	}

	override func accessibilityPerformEscape() -> Bool {
		self.vm.accessibilityPerformEscape()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

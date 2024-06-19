import UIKit

public extension Array where Element == Any? {

	/// Простой способ получить из списка [UIView?] массив, для подстановки в UIView.accessibilityElements
	func accessibilityElements() -> [Any]? {
		self.compactMap { $0 }.accessibilityElements()
	}

}

public extension Array where Element == Any {
	/// Простой способ получить из списка UIView массив, для подстановки в UIView.accessibilityElements
	func accessibilityElements() -> [Any]? {
		let elements = self.filter {
			if let view = $0 as? UIView {
				return !view.isHidden && view.alpha > 0
			}
			return true
		}
		if elements.isEmpty {
			return nil
		}
		return elements
	}
}

public extension Array where Element: UIView {
	/// Простой способ получить из списка UIView массив, для подстановки в UIView.accessibilityElements
	func accessibilityElements() -> [Any]? {
		let elements = self.filter { !$0.isHidden && $0.alpha > 0 }
		if elements.isEmpty {
			return nil
		}
		return elements
	}
}

typealias AccessibilityElementsBlock = () -> [Any?]?

class BaseView: UIView {
	/// Возможность переопределить текущую Accessibility иерархию задав блок для view снаружи
	var customAccessibilityElementsBlock: AccessibilityElementsBlock?

	override var accessibilityElements: [Any]? {
		get { self.customAccessibilityElementsBlock?()?.accessibilityElements() ?? super.accessibilityElements }
		set { super.accessibilityElements = newValue }
	}
}

class VM3: BaseVM {

}

class BaseVM: NSObject {

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

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

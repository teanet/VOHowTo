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

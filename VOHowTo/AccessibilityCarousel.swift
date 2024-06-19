import UIKit

/// специальная обертка над UICollectionView, которая превращает ее из линейного списка в "настраиваемый" контрол.
/// Это нужно чтобы сократить количество свайпов при Accessibility навигации.
/// Например для сториз из 40 элементов на дашборде чтобы перейти с следующему за сториз элементу, нужно совершить 40 свайпов вправо.
/// Если поменять коллекцию на карусель, то нужно будет сделать один свайп вправо. Навигация внутри карусели осуществляется путем свайпа вверх/вниз,
/// Вызывая методы accessibilityIncrement/accessibilityDecrement после вызова метода, автоматом будет проговорено значение из accessibilityValue.
/// Таким контролом почти всегда удобнее пользоваться чем длинным списком
public class AccessibilityCarousel: UIAccessibilityElement {

	private let countTemplate: String?
	private let collectionView: UICollectionView
	private lazy var focusedIndexPath: IndexPath = {
		self.initialFocusedIndexPath ??
		self.collectionView.indexPathsForSelectedItems?.first ??
		IndexPath(item: 0, section: 0)
	}()
	private let supportAccessibilityScroll: Bool
	private let initialFocusedIndexPath: IndexPath?

	/// - Parameters:
	///   - collectionViewProvider: штука, которая содержит UICollectionView, котрорую нужно превратить в карусель
	///   - title: Значение, которое будет сказано при первой фокусировке на элемент
	///   - focusedIndexPath: IndexPath, который должен быть выбран по умолчанию
	///   - countTemplate: строка вида "%@ из %@", которая будет присоединена к описанию ячейки, чтобы сказать пользователю, сколько элементов в коллекции
	///   - supportAccessibilityScroll: можно ли скролить контрол accessibility жестом (3 пальцами влево/вправо)
	public init(
		collectionViewProvider: IAccessibilityCollectionViewProvider,
		title: String?,
		focusedIndexPath: IndexPath? = nil,
		countTemplate: String?,
		supportAccessibilityScroll: Bool = false
	) {
		self.supportAccessibilityScroll = supportAccessibilityScroll
		self.countTemplate = countTemplate
		self.collectionView = collectionViewProvider.accessibilityCollectionView
		self.initialFocusedIndexPath = focusedIndexPath
		super.init(accessibilityContainer: self.collectionView)
		self.accessibilityTraits = [.adjustable, .button]
		self.accessibilityLabel = title
	}

	// MARK: - Accessibility

	public override var accessibilityFrame: CGRect {
		get {
			UIAccessibility.convertToScreenCoordinates(self.collectionView.bounds, in: self.collectionView)
		}
		set { _ = newValue }
	}

	public override func accessibilityElementDidBecomeFocused() {
		super.accessibilityElementDidBecomeFocused()
		self.updateSelection()
	}

	public override var accessibilityValue: String? {
		get {
			guard let cell = self.collectionView.cellForItem(at: self.focusedIndexPath) else { return nil }

			var values = [
				cell.accessibilityLabel,
				cell.accessibilityValue,
			]
			if let countTemplate {
				let row = self.focusedIndexPath.row + 1
				let of = self.collectionView.numberOfItems(inSection: self.focusedIndexPath.section)
				values.append(String(format: countTemplate, "\(row)", "\(of)"))
			}
			return values.accessibilityLabel()
		}
		set { _ = newValue }
	}

	/// Overriding the following two methods allows the user to perform increment and decrement actions done by swiping up
	public override func accessibilityIncrement() {
		// This causes the picker to move forward one if the user swipes up.
		self.scrollNext()
	}

	/// Overriding the following two methods allows the user to perform increment and decrement actions done by swiping down
	public override func accessibilityDecrement() {
		self.scrollPrevious()
	}

	/*
	 This will cause the picker to move forward or backwards on when the user does a 3-finger swipe,
	 depending on the direction of the swipe. The return value indicates whether or not the scroll was successful,
	 so that VoiceOver can alert the user if it was not.
	 */
	public override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
		guard self.supportAccessibilityScroll else { return false }

		if direction == .left {
			return self.scrollNext()
		} else if direction == .right {
			return self.scrollPrevious()
		}
		return false
	}

	public override func accessibilityActivate() -> Bool {
		guard self.collectionView.cellForItem(at: self.focusedIndexPath) != nil else { return false }
		self.collectionView.selectAsUser(at: self.focusedIndexPath)
		return true
	}

	private func updateSelection() {
		if let cell = self.collectionView.cellForItem(at: self.focusedIndexPath) {
			let frame = cell.convert(cell.bounds, to: self.collectionView.superview)
			self.accessibilityFrameInContainerSpace = frame
		} else {
			self.accessibilityFrameInContainerSpace = self.collectionView.frame
		}
		UIAccessibility.post(notification: .layoutChanged, argument: self)
	}

	@discardableResult
	private func scrollNext() -> Bool {
		guard let next = self.collectionView.nextPath(for: self.focusedIndexPath) else { return false }

		self.focusedIndexPath = next
		UIView.animate(withDuration: 0.3, animations: {
			self.collectionView.scrollToItem(at: next, at: .centeredHorizontally, animated: false)
		}, completion: { _ in
			self.updateSelection()
		})
		return true
	}

	@discardableResult
	private func scrollPrevious() -> Bool {
		guard let previous = self.collectionView.previousPath(for: self.focusedIndexPath) else { return false }

		self.focusedIndexPath = previous
		UIView.animate(withDuration: 0.3, animations: {
			self.collectionView.scrollToItem(at: previous, at: .centeredHorizontally, animated: false)
		}, completion: { _ in
			self.updateSelection()
		})
		return true
	}
}

private extension UICollectionView {

	func selectAsUser(at indexPath: IndexPath) {
		self.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
		self.delegate?.collectionView?(self, didSelectItemAt: indexPath)
	}

	func nextPath(for path: IndexPath) -> IndexPath? {
		let numberOfItemsInCurrentSection = numberOfItems(inSection: path.section)

		if path.row + 1 < numberOfItemsInCurrentSection {
			// Same section
			return IndexPath(row: path.row + 1, section: path.section)
		}

		if path.section + 1 < numberOfSections {
			// Next section, first item
			return IndexPath(row: 0, section: path.section + 1)
		}
		// Can‘t move forward
		return nil
	}

	func previousPath(for path: IndexPath) -> IndexPath? {
		if path.row > 0 {
			// Same section
			return IndexPath(row: path.row - 1, section: path.section)
		}

		if path.section > 0 {
			// Next section, first item
			let prevSection = path.section - 1
			let lastRowInPrevSection = numberOfItems(inSection: prevSection) - 1
			return IndexPath(row: lastRowInPrevSection, section: prevSection)
		}
		return nil
	}

}

public protocol IAccessibilityCollectionViewProvider {
	var accessibilityCollectionView: UICollectionView { get }
}

extension UICollectionView: IAccessibilityCollectionViewProvider {
	public var accessibilityCollectionView: UICollectionView { self }
}

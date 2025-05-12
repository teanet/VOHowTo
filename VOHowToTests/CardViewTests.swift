import XCTest
@testable import VOHowTo
import Nimble

final class CardViewTests: XCTestCase {

	public private(set) lazy var uiTester: UITester = {
		let tester = UITester(file: #file, line: #line, delegate: self)
		return tester
	}()

	func test_проверяем_доступность_элемента_списка() throws {

		let viewModel = CardViewVM()
		viewModel.duration = 17 * 60
		let cardView = CardView(
			frame: CGRect(
				x: 0,
				y: 0,
				width: 320,
				height: 250
			),
			isAccessibilityElement: true,
			viewModel: viewModel
		)
		self.uiTester.showView(cardView)

		cardView.printAccessibilityHierarchySnapshot()

		expect(cardView).to(haveAccessibilityHierarchyOfElements([
			.label("Аквасервис, Мойка самообслуживания, Rating: 2.2, Rating count: 152, Route duration, 17 minutes, Автомойки самообслуживания для легковых автомобилей. Button."),
		]))
	}

	func test_проверяем_доступность_элемента_списка_сложный() throws {
		let viewModel = CardViewVM()
		viewModel.duration = 18 * 60
		let cardView = CardView(
			frame: CGRect.init(
				x: 0,
				y: 0,
				width: 320,
				height: 250
			),
			isAccessibilityElement: false,
			viewModel: viewModel
		)
		let vc = UIViewController()
		vc.view.addSubview(cardView)
		self.uiTester.showChild(vc)

		cardView.printAccessibilityHierarchySnapshot()

		expect(cardView).to(haveAccessibilityHierarchyOfElements([
			.label("icon 1. Image."),
			.label("icon 2. Image."),
			.label("icon 3. Image."),
			.label("icon 4. Image."),
			.label("Аквасервис"),
			.label("Мойка самообслуживания"),
			.label("Image."),
			.label("2.2"),
			.label("Rating count: 152"),
			.label("18m"),
			.label("car. Image."),
			.label("Автомойки самообслуживания для легковых автомобилей"),
		]))
	}
}

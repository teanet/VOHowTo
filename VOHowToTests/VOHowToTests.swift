import XCTest
@testable import VOHowTo
import Nimble

final class VOHowToTests: XCTestCase {

	public private(set) lazy var uiTester: UITester = {
		let tester = UITester(file: #file, line: #line, delegate: self)
		return tester
	}()

	override func tearDownWithError() throws {
		try self.uiTester.tearDownWithError()
	}

	func test_проверяем_иерахию_простого_контроллера() throws {
		let vc = ViewController()
		self.uiTester.showChild(vc)

		expect(vc.view).to(haveAccessibilityHierarchyOfElements([
			.label("Red button. Button."),
			.label("SwiftUI green walk button. Button."),
		]))
	}

	func test_проверяем_корректные_label_для_vc() throws {
		let vc = StoriesExampleVC(vm: StoriesExampleVM())
		self.uiTester.showChild(vc)

		// подождем пока collection view загрузит ячейки
		self.uiTester.waitForView(identifier: "cell_0")

		expect(vc.view).to(haveAccessibilityHierarchyOfElements([
			.label("Какой то бесконечный список: ячейка, 1, 1 из 5000. Button. Adjustable."),
			.label("Some other label"),
			.label("Some text. Button."),
		]))

		// скрываем в реальном времени один из элементов
		self.uiTester.tapView(identifier: "label_button")

		// иерархия автоматически пересчитывается при изменении видимости одного из элементов
		expect(vc.view).to(haveAccessibilityHierarchyOfElements([
			.label("Какой то бесконечный список: ячейка, 1, 1 из 5000. Button. Adjustable."),
			.label("Some text. Button."),
		]))

		expect(vc.view).to(haveAccessibilityHierarchyOfElements([
			.label("Label 1"),
			.label("Label 2"),
			.label("Label 3"),
			.label("Button. Button."),
		]))
	}

}

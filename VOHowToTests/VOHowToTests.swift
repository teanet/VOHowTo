import XCTest
@testable import VOHowTo
import Nimble

final class VOHowToTests: XCTestCase {

	public private(set) lazy var uiTester: UITester = {
		let tester = UITester(file: #file, line: #line, delegate: self)
		return tester
	}()

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		try self.uiTester.tearDownWithError()
	}

	func test_проверяем_корректные_label_для_vc() throws {
		let vc = VC3(vm: VM3())
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
	}

}

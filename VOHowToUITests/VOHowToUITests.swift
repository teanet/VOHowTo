import XCTest
import Nimble

final class VOHowToUITests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.

		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false

		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func test_работает_как_тест_и_не_находит_кнопку() throws {
		let app = XCUIApplication().customLaunch()

		expect(app.buttons["label_button"].firstMatch.label) == "Some text"
	}

	func test_работает_как_настоящее_приложение_для_людей_и_там_будет_кнопка() throws {
		let app = XCUIApplication().customLaunch(asUser: true)

		expect(app.buttons["label_button"].firstMatch.label) == "Some text"
	}

}

extension XCUIApplication {
	@discardableResult
	/// Запустить приложение для тестов, или как для обычного пользователя
	func customLaunch(asUser: Bool = false) -> XCUIApplication {
		if !asUser {
			self.launchEnvironment["v4ios_uitests"] = "YES"
		}
		self.launch()
		return self
	}
}

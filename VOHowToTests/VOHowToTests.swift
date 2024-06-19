import XCTest
@testable import VOHowTo
import KIF
import Nimble

final class VOHowToTests: XCTestCase {

	public private(set) lazy var uiTester: UITester = {
		let tester = UITester(file: #file, line: #line, delegate: self)
		return tester
	}()

	private weak var presentedVC: UIViewController?

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		self.presentedVC?.dgs_removeFromParent()
	}

	func test_проверяем_корректные_label_для_vc() throws {
		let vc = VC3(vm: VM3())
		self.showChild(vc)

		expect(vc.view).to(haveAccessibilityHierarchyOfElements([
			.label("Some text. Button."),
			.label("Some other label"),
		]))

		// скрываем в реальном времени один из элементов
		try self.uiTester.view(identifier: "label2").isHidden = true

		// иерархия автоматически пересчитывается
		expect(vc.view).to(haveAccessibilityHierarchyOfElements([
			.label("Some text. Button."),
		]))
	}

	func showChild(_ vc: UIViewController) {
		self.presentedVC = vc
		UIApplication.shared.activeSceneKeyWindow?.rootViewController?.showChild(vc)
	}
}

public final class UITester {
	private let testActor: KIFUITestActor

	init(file: String, line: Int, delegate: KIFTestActorDelegate) {
		self.testActor = KIFUITestActor(inFile: file, atLine: line, delegate: delegate)
	}

	@discardableResult
	public func view<T: UIView>(identifier: String) throws -> T {
		var view: UIView?
		try self.testActor.tryFinding(
			nil,
			view: &view,
			withIdentifier: identifier,
			tappable: false
		)
		return try XCTUnwrap(view as? T)
	}
}

extension UIViewController {
	func showChild(_ vc: UIViewController) {
		self.addChild(vc)
		vc.view.frame = self.view.bounds
		self.view.addSubview(vc.view)
		vc.didMove(toParent: self)
	}

	func dgs_removeFromParent() {
		guard self.parent != nil else { return }
		self.willMove(toParent: nil)
		self.viewIfLoaded?.removeFromSuperview()
		self.removeFromParent()
	}

}

extension UIApplication {

	/// `keyWindow` активной в данный момент сцены.
	var activeSceneKeyWindow: UIWindow? {
		self.connectedScenes
			.lazy
			.compactMap { $0 as? UIWindowScene }
			.filter { $0.activationState == .foregroundActive }
			.flatMap { $0.windows }
			.first { $0.isKeyWindow }
	}
}

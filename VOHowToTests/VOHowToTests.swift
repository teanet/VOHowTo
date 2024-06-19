import XCTest
@testable import VOHowTo
import KIF
import Nimble

final class VOHowToTests: XCTestCase {

	private weak var presentedVC: UIViewController?

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		self.presentedVC?.dgs_removeFromParent()
	}

	func test_vc_() throws {
		let vc = VC3(vm: VM3())
		self.showChild(vc)

		expect(vc.view).to(haveAccessibilityHierarchyOfElements([
			.label("Some text. Button."),
			.label("Some other label"),
		]))
	}

	func showChild(_ vc: UIViewController) {
		self.presentedVC = vc
		UIApplication.shared.activeSceneKeyWindow?.rootViewController?.showChild(vc)
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

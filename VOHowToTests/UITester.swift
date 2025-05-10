import KIF

public final class UITester {
	private let testActor: KIFUITestActor
	private weak var presentedVC: UIViewController?
	private weak var presentedView: UIView?

	init(file: String, line: Int, delegate: KIFTestActorDelegate) {
		self.testActor = KIFUITestActor(inFile: file, atLine: line, delegate: delegate)
	}

	func showChild(_ vc: UIViewController) {
		self.presentedVC = vc
		UIApplication.shared.activeSceneKeyWindow?.rootViewController?.showChild(vc)
	}

	func showView(_ view: UIView) {
		self.presentedView = view
		UIApplication.shared.activeSceneKeyWindow?.addSubview(view)
		view.layoutIfNeeded()
	}

	func waitForView(identifier: String) {
		self.testActor.waitForView(withAccessibilityIdentifier: identifier)
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

	public func tapView(identifier: String) {
		self.testActor.tapView(withAccessibilityIdentifier: identifier)
	}

	func tearDownWithError() throws {
		self.presentedVC?.dgs_removeFromParent()
		self.presentedView?.removeFromSuperview()
	}
}



extension UIViewController {
	func showChild(_ vc: UIViewController) {
		self.addChild(vc)
		vc.view.frame = self.view.bounds
		self.view.addSubview(vc.view)
		vc.view.layoutIfNeeded()
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

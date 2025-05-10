import Foundation

extension ProcessInfo {
	static var isUITests: Bool {
		ProcessInfo.processInfo.environment["v4ios_uitests"] == "YES"
	}
}

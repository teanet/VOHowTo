import Nimble
import AccessibilitySnapshot

public func haveAccessibilityHierarchyOfElements(
	_ elements: [AccessibilitySnapshotElement],
	file: String = #file,
	line: UInt = #line
) -> Nimble.Matcher<UIView> {
	return Nimble.Matcher { actualExpression in
		guard let view = try actualExpression.evaluate() else {
			return MatcherResult(status: .fail, message: .fail("You should call it on existing view"))
		}

		let parser = AccessibilityHierarchyParser()
		let actual = parser.parseAccessibilityElements(in: view).map { $0.toSnapshotElement() }

		guard actual == elements else {
			let expectedElements = AccessibilitySnapshotElements(elements: elements)
			let actualElements = AccessibilitySnapshotElements(elements: actual)
			let message = expectedElements.notMatchDiff(actualElements)
			return MatcherResult(status: .fail, message: message)
		}
		return MatcherResult(status: .matches, message: .expectedTo("all pass"))
	}
}

private struct AccessibilitySnapshotElements: CustomDebugStringConvertible {
	let elements: [AccessibilitySnapshotElement]

	public var debugDescription: String {
		var text = [String]()
		for (idx, element) in self.elements.enumerated() {
			text.append("\t\(idx)\(element.debugDescription)")
		}
		return """
[
\(text.joined(separator: "\n"))
]
"""
	}

	func notMatchDiff(_ other: AccessibilitySnapshotElements) -> ExpectationMessage {
		var message = ExpectationMessage.details(.fail("Accessibility elements not match"), "Expected\n\(self)\n\nGot\n\(other)")
		var notMatchIndexes: [Int] = []
		let max = max(self.elements.count, other.elements.count)
		for idx in 0..<max {
			if self.elements.safeObject(at: idx) != other.elements.safeObject(at: idx) {
				notMatchIndexes.append(idx)
			}
		}
		message = message.appended(details: "Not match indexes \(notMatchIndexes)")
		return message
	}

}

private extension AccessibilityMarker {
	func toSnapshotElement() -> AccessibilitySnapshotElement {
		AccessibilitySnapshotElement(label: self.description, actions: self.customActions)
	}
}

private extension Array {

	func isIndexValid(index: Int) -> Bool {
		return index >= 0 && index < self.count
	}

	func safeObject(at index: Int) -> Element? {
		guard self.isIndexValid(index: index) else { return nil }
		return self[index]
	}
}

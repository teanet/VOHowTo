import AccessibilitySnapshot

public extension UIView {
	/// Вывести в виде строки текущую иерархию, чтобы ее можно было подставить в тест
	func printAccessibilityHierarchySnapshot() {
		let parser = AccessibilityHierarchyParser()
		let markers = parser.parseAccessibilityElements(in: self)
		var string = "[\n"
		string += markers
			.map { $0.hierarchySnapshot() }
			.joined(separator: "\n")
		string += "\n]"
		print("\(string)")
	}
}

private extension AccessibilityMarker {
	func hierarchySnapshot() -> String {
		if self.customActions.isEmpty {
			return """
\t.label("\(self.description)"),
"""
		} else {
			return """
\t.label(
\t\t"\(self.description)",
\t\tactions: [\(self.customActions.map({ "\"\($0)\""}).joined(separator: ","))]
\t),
"""
		}
	}
}

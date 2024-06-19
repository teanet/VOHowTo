/// Структура, описывающая слепок одного элемента иерархии в таком виде, в котором он произносится для пользователя
public struct AccessibilitySnapshotElement: Equatable, CustomDebugStringConvertible {

	/// The description of the accessibility element that will be read by VoiceOver when the element is brought into focus.
	public var label: String

	/// The names of the custom actions supported by the element.
	public var actions: [String] = []

	public static func label(_ label: String, actions: [String] = []) -> AccessibilitySnapshotElement {
		AccessibilitySnapshotElement(label: label, actions: actions)
	}

	public var debugDescription: String {
		var label = "<\(self.label)>"
		if !self.actions.isEmpty {
			label += " [actions]\(self.actions)"
		}
		return label
	}
}

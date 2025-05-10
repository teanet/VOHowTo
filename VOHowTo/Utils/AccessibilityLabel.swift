import Foundation

public extension Array where Element == String {

	func accessibilityLabel() -> String {
		self
		// нужно задать лейбл без переносов строк. пожелание от пользователей
			.compactMap { $0.replacingNewLinesBySpaces }
			.joined(separator: ", ")
	}

}

public extension Array where Element == String? {

	func accessibilityLabel() -> String {
		self.compactMap { $0 }.accessibilityLabel()
	}

}


private extension String {
	/// Непустая версия себя без пробелов и переносов строк вначале и в конце, а так же без переносов строк в середине
	///
	/// Если конечная версия - пустая, вернется `nil`
	var replacingNewLinesBySpaces: Self? {
		let finalString = self
			.components(separatedBy: .whitespacesAndNewlines)
			.filter { !$0.isEmpty }
			.joined(separator: " ")

		return finalString.isEmpty ? nil : finalString
	}
}

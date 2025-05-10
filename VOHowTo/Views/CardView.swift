import UIKit

class CardViewVM: NSObject {
	var title: String? = "Аквасервис"
	var subtitle: String? = "Мойка самообслуживания"
	var rating: Double = 2.2
	var ratingCount: Int = 152
	var details: String? = "Автомойки самообслуживания для легковых автомобилей"

	var ratingTitle: String {
		"Rating: \(rating)"
	}

	var ratingCountTitle: String {
		"Rating count: \(ratingCount)"
	}

	var duration: TimeInterval = 17 * 60

	var durationTitle: String? {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.minute, .second]
		formatter.unitsStyle = .abbreviated
		return formatter.string(from: duration) ?? ""
	}

	var durationAccessibilityTitle: String? {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.minute, .second]
		formatter.unitsStyle = .full
		let title = formatter.string(from: duration) ?? ""
		return ["Route duration", title].accessibilityLabel()
	}

	override var accessibilityLabel: String? {
		get {
			[
				self.title,
				self.subtitle,
				self.ratingTitle,
				self.ratingCountTitle,
				self.durationAccessibilityTitle,
				self.details,
			].accessibilityLabel()
		}
		set {}
	}
}

final class CardView: UIView {

	let viewModel: CardViewVM

	override var accessibilityLabel: String? {
		get { self.viewModel.accessibilityLabel }
		set {}
	}

	init(frame: CGRect, isAccessibilityElement: Bool, viewModel: CardViewVM) {
		self.viewModel = viewModel
		super.init(frame: frame)

		self.isAccessibilityElement = isAccessibilityElement
		self.accessibilityTraits = .button

		let stack = UIStackView(
			arrangedSubviews: [
				makeIcon(idx: 1),
				makeIcon(idx: 2),
				makeIcon(idx: 3),
				makeIcon(idx: 4),
			]
		)
		stack.spacing = 8
		stack.frame = CGRect(x: 10, y: 10, width: self.bounds.width - 20, height: 80)
		stack.distribution = .fillEqually

		self.backgroundColor = .lightGray
		self.layer.cornerRadius = 10
		self.layer.masksToBounds = true

		self.addSubview(stack)

		let vStack = UIStackView()
		vStack.spacing = 4
		vStack.axis = .vertical
		vStack.alignment = .leading
		vStack.distribution = .equalSpacing
		vStack.frame = CGRect(x: 10, y: 95, width: self.bounds.width - 20, height: 120)
		self.addSubview(vStack)

		let title = UILabel()
		title.text = viewModel.title
		vStack.addArrangedSubview(title)

		let subtitle = UILabel()
		subtitle.text = viewModel.subtitle
		vStack.addArrangedSubview(subtitle)

		let ratingStack = UIStackView()
		ratingStack.spacing = 4
		ratingStack.axis = .horizontal
		ratingStack.distribution = .equalSpacing
		vStack.addArrangedSubview(ratingStack)

		let ratingTitle = UILabel()
		ratingTitle.text = viewModel.ratingTitle
		ratingStack.addArrangedSubview(ratingTitle)

		let ratingCount = UILabel()
		ratingCount.text = viewModel.ratingCountTitle
		ratingStack.addArrangedSubview(ratingCount)

		let routeIcon = UIImageView(image: UIImage(systemName: "car"))
		ratingStack.addArrangedSubview(routeIcon)

		let duration = UILabel()
		duration.text = viewModel.durationTitle
		ratingStack.addArrangedSubview(duration)

		let details = UILabel()
		details.text = viewModel.details
		vStack.addArrangedSubview(details)
	}

	func makeIcon(idx: Int) -> UIImageView {
		let image = UIImageView()
		image.isAccessibilityElement = true
		image.accessibilityLabel = "icon \(idx)"
		image.layer.cornerRadius = 10
		image.layer.masksToBounds = true
		image.backgroundColor = .darkGray
		return image
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

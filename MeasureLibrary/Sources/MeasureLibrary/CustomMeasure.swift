import Foundation

public protocol CustomMeasureProvider {
    var customMeasures: [CustomMeasure] { get set }
    func updateMeasures(_ measures: [CustomMeasure])
}

public struct CustomMeasure {
    public var id: String
    public var title: String
    public var baseUnitSymbol: String
    public var coefficient: Double
    
    public init(id: String = UUID().uuidString,
                title: String,
                baseUnitSymbol: String,
                coefficient: Double) {
        self.id = id
        self.title = title
        self.baseUnitSymbol = baseUnitSymbol
        self.coefficient = coefficient
    }
}

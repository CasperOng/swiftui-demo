import SwiftUI
import Charts

struct SalesData: Identifiable {
    let id = UUID()
    let month: String
    let sales: Double
    let profit: Double
}

struct ChartsDemoView: View {
    let salesData: [SalesData] = [
        SalesData(month: "Jan", sales: 1000, profit: 200),
        SalesData(month: "Feb", sales: 1500, profit: 300),
        SalesData(month: "Mar", sales: 1200, profit: 250),
        SalesData(month: "Apr", sales: 1800, profit: 400),
        SalesData(month: "May", sales: 2000, profit: 500),
        SalesData(month: "Jun", sales: 2200, profit: 600)
    ]
    
    var body: some View {
        List {
            Section("Bar Chart") {
                Chart(salesData) { data in
                    BarMark(
                        x: .value("Month", data.month),
                        y: .value("Sales", data.sales)
                    )
                    .foregroundStyle(.blue.gradient)
                }
                .frame(height: 200)
                .padding()
            }
            
            Section("Line Chart") {
                Chart(salesData) { data in
                    LineMark(
                        x: .value("Month", data.month),
                        y: .value("Sales", data.sales)
                    )
                    .foregroundStyle(.green)
                    .symbol(.circle)
                }
                .frame(height: 200)
                .padding()
            }
            
            Section("Area Chart") {
                Chart(salesData) { data in
                    AreaMark(
                        x: .value("Month", data.month),
                        y: .value("Sales", data.sales)
                    )
                    .foregroundStyle(.blue.opacity(0.2))
                }
                .frame(height: 200)
                .padding()
            }
            
            Section("Multiple Series") {
                Chart(salesData) { data in
                    BarMark(
                        x: .value("Month", data.month),
                        y: .value("Sales", data.sales)
                    )
                    .foregroundStyle(.blue.gradient)
                    
                    BarMark(
                        x: .value("Month", data.month),
                        y: .value("Profit", data.profit)
                    )
                    .foregroundStyle(.green.gradient)
                }
                .frame(height: 200)
                .padding()
            }
            
            Section("Scatter Plot") {
                Chart(salesData) { data in
                    PointMark(
                        x: .value("Sales", data.sales),
                        y: .value("Profit", data.profit)
                    )
                    .foregroundStyle(.purple)
                    .symbolSize(100)
                }
                .frame(height: 200)
                .padding()
            }
            
            Section("Interactive Chart") {
                Chart(salesData) { data in
                    BarMark(
                        x: .value("Month", data.month),
                        y: .value("Sales", data.sales)
                    )
                    .foregroundStyle(.blue.gradient)
                }
                .frame(height: 200)
                .padding()
                .chartXSelection(value: .constant("Jan"))
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel()
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel()
                    }
                }
            }
        }
        .navigationTitle("Charts Demo")
    }
}

#Preview {
    NavigationStack {
        ChartsDemoView()
    }
} 
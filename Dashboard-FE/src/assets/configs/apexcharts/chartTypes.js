export const chartTypes = {
	DonutChart: "圓餅圖",
	BarChart: "橫向長條圖",
	ColumnChart: "縱向長條圖",
	BarPercentChart: "長條圖(%)",
	TreemapChart: "矩形圖",
	DistrictChart: "行政區圖",
	MetroChart: "捷運行駛圖",
	TimelineSeparateChart: "折線圖(比較)",
	TimelineStackedChart: "折線圖(堆疊)",
	GuageChart: "量表圖",
	RadarChart: "雷達圖",
	HeatmapChart: "熱力圖",
	PolarAreaChart: "極座標圖",
	ColumnLineChart: "長條折線圖",
	BarChartWithGoal: "長條圖(目標)",
	IconPercentChart: "圖示比例圖",
	SpeedometerChart: "儀表板圖",
	IndicatorChart: "指標圖",
	MapLegend: "地圖圖例",
};

export const chartsPerDataType = {
	two_d: [
		"DonutChart",
		"BarChart",
		"ColumnChart",
		"TreemapChart",
		"DistrictChart",
		"RadarChart",
		"PolarAreaChart",
		"MetroChart",
	],
	three_d: [
		"ColumnChart",
		"BarPercentChart",
		"RadarChart",
		"DistrictChart",
		"HeatmapChart",
		"IndicatorChart",
		"PolarAreaChart",
	],
	time: ["TimelineSeparateChart", "TimelineStackedChart", "ColumnLineChart"],
	percent: [
		"GuageChart",
		"BarPercentChart",
		"BarChartWithGoal",
		"IconPercentChart",
	],
	map_legend: ["MapLegend"],
};
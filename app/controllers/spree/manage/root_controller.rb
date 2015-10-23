module Spree
  module Manage
    class RootController < Spree::Manage::BaseController

      #skip_before_filter :authorize_admin

      def index
				# temporarily forwarding to products#index as landing page
        redirect_to manage_root_redirect_path
      end

      def overview
        @vendor = current_vendor
				build_sales_line_chart
				build_sales_bar_chart
				build_sales_pie_chart
        render :overview
      end

			# http://jsfiddle.net/gh/get/jquery/1.7.2/highslide-software/highcharts.com/tree/master/samples/highcharts/plotoptions/area-fillcolor-gradient/
			def build_sales_line_chart
				@sales_overtime_chart = LazyHighCharts::HighChart.new('graph') do |f|
  				f.chart({:type=>"area"})
				  f.title(:text => "Sales Over Time - 2015")
					f.xAxis(:categories => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'])
					f.series(
            data: [29.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
        	)
				  #f.series(:name => "GDP in Billions", :yAxis => 0, :data => [14119, 5068, 4985, 3339, 2656])
  				#f.series(:name => "Population in Millions", :yAxis => 1, :data => [310, 127, 1340, 81, 65])

  				#f.yAxis [
  				#  {:title => {:text => "GDP in Billions", :margin => 70} },
  				#  {:title => {:text => "Population in Millions"}, :opposite => true},
  				#]

					f.plotOptions(series: {
								color: 'orange',
                fillColor: 
									{
                    linearGradient: [0, 0, 0, 300],
                    stops: [
                        [0,'orange' ],
                        [1, 'white']
                    ]
                }
            }
					)

  				#f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
				end	
			end

			# http://jsfiddle.net/gh/get/jquery/1.9.1/highslide-software/highcharts.com/tree/master/samples/highcharts/demo/column-drilldown/
			def build_sales_bar_chart
				@customer_sales_bar_chart = LazyHighCharts::HighChart.new('graph') do |f|
  				f.chart({:type=>"column", :className=>"bar active"})
				  f.title(:text => "Sales by Customer, Last 12 Months")
					f.series(
						name: "Brands",
            colorByPoint: true,
            data: [{
                name: "Microsoft Internet Explorer",
                y: 56.33,
                #drilldown: "Microsoft Internet Explorer"
                #drilldown: null
            }, {
                name: "Chrome",
                y: 24.03,
                #drilldown: "Chrome"
                #drilldown: null
            }, {
                name: "Firefox",
                y: 10.38,
                #drilldown: "Firefox"
                #drilldown: null
            }, {
                name: "Safari",
                y: 4.77,
                #drilldown: "Safari"
                #drilldown: null
            }, {
                name: "Opera",
                y: 0.91,
                #drilldown: "Opera"
                #drilldown: null
            }, {
                name: "Proprietary or Undetectable",
                y: 0.2,
                #drilldown: null
            }]
        	)

				end	
			end

			# http://jsfiddle.net/gh/get/jquery/1.7.2/highslide-software/highcharts.com/tree/master/samples/highcharts/demo/pie-basic/
			def build_sales_pie_chart
				@customer_sales_pie_chart = LazyHighCharts::HighChart.new('graph') do |f|
  				f.chart({:type=>"pie", :className=>"pie active", margin: [30,30,70,30]})
				  f.title(:text => "Sales by Customer, Last 12 Months")
				  f.tooltip(pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>')
					f.plotOptions(
						pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                    style: {
                        #color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        color: 'orange'
                    }
                }
            }
					)

					f.series(
						name: "Brands",
            colorByPoint: true,
            data: [{
                name: "Microsoft Internet Explorer",
                y: 56.33,
                #drilldown: "Microsoft Internet Explorer"
                #drilldown: null
            }, {
                name: "Chrome",
                y: 24.03,
                #drilldown: "Chrome"
                #drilldown: null
            }, {
                name: "Firefox",
                y: 10.38,
                #drilldown: "Firefox"
                #drilldown: null
            }, {
                name: "Safari",
                y: 4.77,
                #drilldown: "Safari"
                #drilldown: null
            }, {
                name: "Opera",
                y: 0.91,
                #drilldown: "Opera"
                #drilldown: null
            }, {
                name: "Proprietary or Undetectable",
                y: 0.2,
                #drilldown: null
            }]
        	)

				end	
			end

      protected

      def manage_root_redirect_path
        # spree.manage_products_path
        spree.manage_overview_path
      end
    end
  end
end

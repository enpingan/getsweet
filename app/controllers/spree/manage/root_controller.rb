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
        month_totals = []
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 1, 1), DateTime.new(2015,2,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 2, 1), DateTime.new(2015,3,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 3, 1), DateTime.new(2015,4,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 4, 1), DateTime.new(2015,5,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 5, 1), DateTime.new(2015,6,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 6, 1), DateTime.new(2015,7,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 7, 1), DateTime.new(2015,8,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 8, 1), DateTime.new(2015,9,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 9, 1), DateTime.new(2015,10,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 10, 1), DateTime.new(2015,11,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 11, 1), DateTime.new(2015,12,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", DateTime.new(2015, 12, 1), DateTime.new(2016,1,1)).sum(:total).to_i

				@sales_overtime_chart = LazyHighCharts::HighChart.new('graph') do |f|
  				f.chart({:type=>"area"})
				  f.title(:text => "Sales Over Time - 2015")
					f.xAxis(:categories => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'])
					f.series(
            name: "Total Sales",
            data: month_totals
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
        c1 = current_vendor.customers.find(1)
        c1_total = c1.orders.where("delivery_date > ? AND vendor_id = ?", 1.year.ago, current_vendor.id).sum(:total)

        c2 = current_vendor.customers.find(2)
        c2_total = c2.orders.where("delivery_date > ? AND vendor_id = ?", 1.year.ago, current_vendor.id).sum(:total)

        c3 = current_vendor.customers.find(3)
        c3_total = c3.orders.where("delivery_date > ? AND vendor_id = ?", 1.year.ago, current_vendor.id).sum(:total)

        c4 = current_vendor.customers.find(4)
        c4_total = c4.orders.where("delivery_date > ? AND vendor_id = ?", 1.year.ago, current_vendor.id).sum(:total)

        c5 = current_vendor.customers.find(5)
        c5_total = c5.orders.where("delivery_date > ? AND vendor_id = ?", 1.year.ago, current_vendor.id).sum(:total)


				@customer_sales_bar_chart = LazyHighCharts::HighChart.new('graph') do |f|
  				f.chart({:type=>"column", :className=>"bar active"})
				  f.title(:text => "Sales by Customer, Last 12 Months")
					f.series(
						name: "Customers",
            colorByPoint: true,
            data: [{
                name: c1.name,
                y: c1_total.to_i,
                #drilldown: "Microsoft Internet Explorer"
                #drilldown: null
            }, {
                name: c2.name,
                y: c2_total.to_i,
                #drilldown: "Chrome"
                #drilldown: null
            }, {
              name: c3.name,
              y: c3_total.to_i,
                #drilldown: "Firefox"
                #drilldown: null
            }, {
                name: c4.name,
                y: c4_total.to_i,
                #drilldown: "Safari"
                #drilldown: null
            }, {
                name: c5.name,
                y: c5_total.to_i,
                #drilldown: "Opera"
                #drilldown: null
            }]
        	)

				end
			end

			# http://jsfiddle.net/gh/get/jquery/1.7.2/highslide-software/highcharts.com/tree/master/samples/highcharts/demo/pie-basic/
			def build_sales_pie_chart
        c1 = current_vendor.customers.find(1)
        c1_total = c1.orders.where("delivery_date > ? AND vendor_id = ?", 1.year.ago, current_vendor.id).sum(:total)

        c2 = current_vendor.customers.find(2)
        c2_total = c2.orders.where("delivery_date > ? AND vendor_id = ?", 1.year.ago, current_vendor.id).sum(:total)

        c3 = current_vendor.customers.find(3)
        c3_total = c3.orders.where("delivery_date > ? AND vendor_id = ?", 1.year.ago, current_vendor.id).sum(:total)

        c4 = current_vendor.customers.find(4)
        c4_total = c4.orders.where("delivery_date > ? AND vendor_id = ?", 1.year.ago, current_vendor.id).sum(:total)

        c5 = current_vendor.customers.find(5)
        c5_total = c5.orders.where("delivery_date > ? AND vendor_id = ?", 1.year.ago, current_vendor.id).sum(:total)

				@customer_sales_pie_chart = LazyHighCharts::HighChart.new('graph') do |f|
  				f.chart({:type=>"pie", :className=>"pie", margin: [30,30,70,30]})
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
						name: "Customers",
            colorByPoint: true,
            data: [{
                name: c1.name,
                y: c1_total.to_i,
                #drilldown: "Microsoft Internet Explorer"
                #drilldown: null
            }, {
                name: c2.name,
                y: c2_total.to_i,
                #drilldown: "Chrome"
                #drilldown: null
            }, {
              name: c3.name,
              y: c3_total.to_i,
                #drilldown: "Firefox"
                #drilldown: null
            }, {
                name: c4.name,
                y: c4_total.to_i,
                #drilldown: "Safari"
                #drilldown: null
            }, {
                name: c5.name,
                y: c5_total.to_i,
                #drilldown: "Opera"
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

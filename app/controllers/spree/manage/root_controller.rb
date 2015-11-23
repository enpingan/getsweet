module Spree
  module Manage
    class RootController < Spree::Manage::BaseController

      #skip_before_filter :authorize_admin
      before_action :clear_current_order

      def index
				# temporarily forwarding to products#index as landing page
        redirect_to manage_root_redirect_path
      end

      def overview
        @vendor = current_vendor
				build_sales_line_chart
				build_sales_bar_chart
				build_sales_pie_chart
        #monthly average over 1 year period
        @customers = @vendor.customers
        @average = @vendor.orders.where('delivery_date > ?', 1.year.ago).sum("total")/ 12.0
        render :overview
      end

			# http://jsfiddle.net/gh/get/jquery/1.7.2/highslide-software/highcharts.com/tree/master/samples/highcharts/plotoptions/area-fillcolor-gradient/
			def build_sales_line_chart
        month_totals = []
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 1, 1), Time.zone.local(2015,2,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 2, 1), Time.zone.local(2015,3,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 3, 1), Time.zone.local(2015,4,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 4, 1), Time.zone.local(2015,5,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 5, 1), Time.zone.local(2015,6,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 6, 1), Time.zone.local(2015,7,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 7, 1), Time.zone.local(2015,8,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 8, 1), Time.zone.local(2015,9,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 9, 1), Time.zone.local(2015,10,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 10, 1), Time.zone.local(2015,11,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 11, 1), Time.zone.local(2015,12,1)).sum(:total).to_i
        month_totals << current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", Time.zone.local(2015, 12, 1), Time.zone.local(2016,1,1)).sum(:total).to_i

				@sales_overtime_chart = LazyHighCharts::HighChart.new('graph') do |f|
  				f.chart({:type=>"area"})
				  f.title(:text => "Sales Over Time - 2015")
          f.legend(enabled: false)
					f.xAxis(:categories => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'])
					f.series(
            name: "Total Sales",
            data: month_totals
        	)

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

        customers = top_customers

				@customer_sales_bar_chart = LazyHighCharts::HighChart.new('graph') do |f|
  				f.chart({:type=>"column", :className=>"bar active"})
				  f.title(:text => "Sales by Customer, Last 12 Months")
          f.legend(enabled: false)
          f.xAxis(:categories => [])
					f.series(
						name: "12 Mo. Sales",
            colorByPoint: true,
            data: [{
                name: Spree::Customer.find(customers[0][0]).name, #customer name
                y: customers[0][1].to_i, #customer annual sales in whole dollars
            }, {
                name: Spree::Customer.find(customers[1][0]).name,
                y: customers[1][1].to_i,
            }, {
                name: Spree::Customer.find(customers[2][0]).name,
                y: customers[2][1].to_i,
            }, {
                name: Spree::Customer.find(customers[3][0]).name,
                y: customers[3][1].to_i,
            }, {
                name: Spree::Customer.find(customers[4][0]).name,
                y: customers[4][1].to_i,
            }]
        	)

				end
			end

			# http://jsfiddle.net/gh/get/jquery/1.7.2/highslide-software/highcharts.com/tree/master/samples/highcharts/demo/pie-basic/
			def build_sales_pie_chart
        customers = top_customers

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
                name: Spree::Customer.find(customers[0][0]).name, #customer name
                y: customers[0][1].to_i, #customer annual sales in whole dollars
            }, {
                name: Spree::Customer.find(customers[1][0]).name,
                y: customers[1][1].to_i,
            }, {
                name: Spree::Customer.find(customers[2][0]).name,
                y: customers[2][1].to_i,
            }, {
                name: Spree::Customer.find(customers[3][0]).name,
                y: customers[3][1].to_i,
            }, {
                name: Spree::Customer.find(customers[4][0]).name,
                y: customers[4][1].to_i,
            }]
        	)
				end
			end

      protected

      def top_customers
        @customers ||= customers = Spree::Vendor.first.orders.where('delivery_date > ?', 1.year.ago).group('customer_id').sum(:total).sort_by{|k, v| v}.reverse[0...5]
      end

      def manage_root_redirect_path
        # spree.manage_products_path
        spree.manage_overview_path
      end
    end
  end
end

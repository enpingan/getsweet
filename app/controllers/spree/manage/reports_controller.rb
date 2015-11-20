module Spree
  module Manage
	   class ReportsController < Spree::Manage::BaseController

       def index
         @reports
         @customer = current_vendor.customers.order('name ASC').first
         build_sales_line_chart
       end

       def show
       end

       def build_sales_line_chart
          customers = []
          customers_totals = []
          current_vendor.customers.order('name ASC').each do |customer|
            customer_totals = []
            customer_totals = customer.orders.select(:total, :delivery_date).where("delivery_date >= ? AND delivery_date < ? AND vendor_id = ?", Time.zone.local(2015, 1, 1), Time.zone.local(2015,12,31), current_vendor.id).order('delivery_date ASC')
            customer_data = customer_totals.map{|c| [c.delivery_date.utc.to_i*1000 , c.total.to_i]}
            customers << [customer.name, customer_data]
          end

         @sales_overtime_chart = LazyHighCharts::HighChart.new('graph') do |f|
           f.chart({:zoomType=>'x'})
           f.title(:text => "Sales Over Time - 2015")

             f.options[:xAxis] = { :type => 'datetime',
              #  :lineWidth => 1,
              #  :tickInterval => (1000 * 60 * 60 * 24 * 60),
              #  :tickmarkPlacement => 'on',
              #  :startOnTick => true,
               :dateTimeLabelFormats => { :month => '%b \'%y' }}

           customers.each do |customer|
             f.series(
                name: customer[0],
                data: customer[1],
                pointStart: Time.zone.local(2015, 1, 1).utc
                # pointInterval:
                # pointStart: Time.at(Time.zone.local(2015, 1, 1).to_i),
                # pointInterval: (1000 * 60 * 60 * 24 * 30)
             )

           end

           f.plotOptions(series: {
                marker: {enabled: false}
                #  stacking: 'precent'
              }
           )

           f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
         end
       end

     end
   end
 end

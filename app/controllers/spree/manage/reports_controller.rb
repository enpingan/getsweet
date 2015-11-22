module Spree
  module Manage
	   class ReportsController < Spree::Manage::BaseController

       def index
         @reports
         @customer = current_vendor.customers.order('name ASC').first
         build_customer_sales_area_chart
         build_product_sales_chart

         render :index
       end

       def show
       end

       def build_customer_sales_area_chart
          customers = []
          customers_totals = []
          current_vendor.customers.order('name ASC').each do |customer|
            customer_totals = []
            customer_totals = customer.orders.select(:total, :delivery_date).where("delivery_date >= ? AND delivery_date < ? AND vendor_id = ?", Time.zone.local(2015, 1, 1), Time.zone.local(2015,12,31), current_vendor.id).order('delivery_date ASC')
            customer_data = customer_totals.map{|c| [c.delivery_date.utc.to_i*1000 , c.total.to_i]}
            customers << [customer.name, customer_data]
          end

         @customer_sales_overtime_chart = LazyHighCharts::HighChart.new('graph') do |f|
           f.chart({:type => 'area', :zoomType=>'x'})
           f.title(:text => "Sales Over Time by Customer")
           f.yAxis(title:{:text => "Total Sales (USD)"})
             f.options[:xAxis] = { :type => 'datetime',
              #  :lineWidth => 1,
              #  :tickInterval => (1000 * 60 * 60 * 24 * 60),
              #  :tickmarkPlacement => 'on',
               :startOnTick => true,
               :dateTimeLabelFormats => { :month => '%b \'%y' }}

           customers.each do |customer|
             f.series(
                name: customer[0],
                data: customer[1],
                pointStart: Time.zone.local(2015, 1, 1).utc,
                # pointInterval:
                # pointStart: Time.at(Time.zone.local(2015, 1, 1).to_i),
                pointInterval: (1000 * 60 * 60 * 24 * 30)
             )

           end

           f.plotOptions(series: {
                marker: {enabled: false},
                 stacking: 'normal'
              }
           )

           f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
         end
       end

       def build_product_sales_chart
         start_date = Time.zone.local(2015, 1, 1)
         end_date = Time.zone.local(2015,12,31)
          customers = Hash.new {|hash, key| hash[key] = Hash.new(0)}
          # product_qtys = Hash.new([])
          product_qtys = Hash.new(0)
          product_totals = Hash.new {|hash, key| hash[key] = []}
          current_vendor.orders.where("delivery_date >= ? AND delivery_date < ?", start_date, end_date).each do |order|
            order.line_items.each do |line_item|
              prod_name = line_item.product.name
                puts order.number.to_s + ' ' + order.customer.name
                product_qtys[prod_name] += line_item.quantity
                puts prod_name.to_s + ' ' + line_item.quantity.to_s + ' ' + product_qtys[prod_name].to_s
                # product_qtys[name] << [line_item.quantity, order.delivery_date]
                # product_totals[name] << [line_item.total, order.delivery_date]
                customers[order.customer.name][prod_name] += line_item.quantity
                puts prod_name.to_s + ' ' + line_item.quantity.to_s + ' ' + customers[order.customer.name].to_s

            end

          end
          @product_sales_bar_chart = LazyHighCharts::HighChart.new('graph') do |f|
            data = []
            drill_series = []

            product_qtys.each do |name, qty|
              drill_data = []
              data << {name: name, y: qty, drilldown: name}

              current_vendor.customers.each do |customer|
                 drill_data << [customer.name, customers[customer.name][name]]
              end

              drill_series << {name: name, id: name, data: drill_data}
            end

            f.plotOptions(
                series: {
                    borderWidth: 0,
                    dataLabels: {
                        enabled: true,
                    }
                }
            )

    				f.chart({:type=>"column", :className=>"bar active"})
  				  f.title(:text => "Sales by Product(#{start_date.to_date} to #{end_date.to_date})")
            f.yAxis(title:{:text => "Quantity"})
            f.legend(enabled: false)
            f.xAxis(:categories => [])
               f.series(
                  colorByPoint: true,
                  name: "Products",
                  data: data
               )
               f.drilldown(
                  series: drill_series
                  # series: [{
                  #   name: ,
                  #   id: ,
                  #   data: [
                  #     []
                  #   ]
                  #   },{
                  #     name: ,
                  #     id: ,
                  #     data: [
                  #       []
                  #     ]
                  #   }]
               )

  				end

      end

     end
   end
 end

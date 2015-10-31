object false
node(:count) { @customers.count }
node(:total_count) { @customers.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page] || Kaminari.config.default_per_page }
node(:pages) { @customers.num_pages }
child(@customers => :customers) do
  attributes :id, :name
end

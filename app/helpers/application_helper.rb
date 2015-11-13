module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def current_order
    session[:order_id] ? Spree::Order.find(session[:order_id]) : nil
  end

  def clear_current_order
    session[:order_id] = nil
  end

  def set_order_session(order = nil)
    order ||= Spree::Order.friendly.find(params[:id])
    session[:order_id] = order.id
    order
  end
end

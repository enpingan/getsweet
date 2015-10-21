Deface::Override.new(:virtual_path => 'spree/admin/orders/_form',
  :name => 'add_delivery_date_to_order',
  :insert_top => "[data-hook='admin_order_form_fields']",
  :text => "
  <%= f.field_container :delivery_date do %>
    <%= f.label :delivery_date, 'Delivery Date' %>
    <%= f.text_field :delivery_date %>
    <%= f.error_message_on :delivery_date %>
  <% end %>
")

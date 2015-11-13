Deface::Override.new(:virtual_path => 'spree/admin/variants/_form',
  :name => 'add_lead_time_to_variant_edit',
  :insert_bottom => "[data-hook='tax_category']",
  :text => "<div class='field alpha columns three' data-hook='lead_time'>
	<%= f.label 'Lead Time (in days)' %>
	<%= f.number_field :lead_time %>
</div>
          ")

Deface::Override.new(:virtual_path => 'spree/admin/products/_form',
  :name => 'add_lead_time_to_admin_product_form',
  :insert_after => "[data-hook='admin_product_form_sku']",
  :text => "<% if !@product.has_variants? %>
	<div class='omega columns two' data-hook='admin_product_form_lead_time'>
		<%= f.field_container :lead_time do %>
			<%= f.label :lead_time, 'Lead Time (in days)' %>
			<%= f.number_field :lead_time %>
			<%= f.error_message_on :lead_time %>
		<% end %>
	</div>
<% end %>
          ")

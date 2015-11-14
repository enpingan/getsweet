Deface::Override.new(:virtual_path => 'spree/admin/variants/_form',
  :name => 'add_pack_size_to_variant_edit',
  :insert_after => "[data-hook='sku']",
  :text => "<div class='form-group' data-hook='pack_size'>
	<%= f.label :pack_size %>
	<%= f.number_field :pack_size, class: 'form-control' %>
</div>
          ")

Deface::Override.new(:virtual_path => 'spree/admin/products/_form',
  :name => 'add_pack_size_to_admin_product_form',
  :insert_after => "[data-hook='admin_product_form_price']",
  :text => "<% if !@product.has_variants? %>
	<div class='alpha two columns' data-hook='admin_product_form_pack_size'>
		<%= f.field_container :pack_size, class: ['form-group field'] do %>
			<%= f.label :pack_size %>
			<%= f.text_field :pack_size, class: 'form-control' %>
			<%= f.error_message_on :pack_size %>
		<% end %>
	</div>
<% end %>
          ")

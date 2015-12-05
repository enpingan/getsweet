Deface::Override.new(:virtual_path => 'spree/admin/products/_form',
  :name => 'add_sku_to_master_form',
  :insert_after => "[data-hook='admin_product_form_price']",
  :text => "<div data-hook='admin_product_form_sku'>
              <%= f.field_container :sku, class: ['form-group'] do %>
                <%= f.label :sku, 'master sku' %>
                <%= f.text_field :sku, value: @product.sku, class: 'form-control' %>
                <%= f.error_message_on :sku %>
              <% end %>
            </div>"
  )

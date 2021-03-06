# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.precompile += %w( spree/scripts.js )
Rails.application.config.assets.precompile += %w( spree/manage/all.css )
Rails.application.config.assets.precompile += %w( spree/cust/all.css )
Rails.application.config.assets.precompile += %w( spree/manage/all.js )
Rails.application.config.assets.precompile += %w( spree/manage/js/chart_scripts.js )
Rails.application.config.assets.precompile += %w( spree/manage/js/jquery.formstyler.min.js )
Rails.application.config.assets.precompile += %w( spree/manage/js/jquery.pickmeup.min.js )
Rails.application.config.assets.precompile += %w( spree/manage/js/jquery.simplemodal.js )
Rails.application.config.assets.precompile += %w( spree/manage/js/classie.js )
Rails.application.config.assets.precompile += %w( spree/manage/js/uisearch.js )
Rails.application.config.assets.precompile += %w( spree/product_search.js )

Rails.application.config.assets.precompile += %w( fonts.css )
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/

Rails.application.config.assets.precompile += %w( logo/spree_50.png )
Rails.application.config.assets.precompile += %w( noimage/small.png )
Rails.application.config.assets.precompile += %w( noimage/mini.png )
Rails.application.config.assets.precompile += %w( noimage/product.png )
Rails.application.config.assets.precompile += %w( noimage/large.png )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

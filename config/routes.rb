Erp::QuickOrders::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :backend, module: "backend", path: "backend/quick_orders" do
      resources :orders do
        collection do
          post 'list'
					get 'order_details'
					delete 'delete_all'
        end
      end
    end
  end
end
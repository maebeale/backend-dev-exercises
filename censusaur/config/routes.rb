Rails.application.routes.draw do
  root "census_data#index"
  get  '/charts',      to: 'census_data#charts',     as: 'charts'
end

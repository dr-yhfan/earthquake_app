EarthquakeApp::Application.routes.draw do
  root 'earthquakes#index'
  get 'earthquakes', to: 'earthquakes#earthquakes', as: :get_earthquakes
end

class ApplicationController < ActionController::API
  WillPaginate.per_page = 10
end

class ApplicationController < ActionController::API
  WillPaginate.per_page = 10

  protected

    def pagination(records)
      {
        pagination: {
          per_page: records.per_page,
          total_pages: records.total_pages,
          total_objects: records.total_entries
        }
      }
    end
end

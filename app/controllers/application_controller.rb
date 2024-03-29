class ApplicationController < ActionController::API
  WillPaginate.per_page = 10
  
  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { message: "Unauthorized OAuth Access" } }
  end

  protected
    def paginate_result(hash, collection)
      hash.merge(pagination: pagination(collection))
    end

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

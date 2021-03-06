module DataMapper
  module ArrayPagination 
    include DataMapper::Pagination  
    def page page = nil, options = {}
      options, page = page, nil if page.is_a? Hash
      page ||= pager_option :page, options
      options.delete :page
      page = 1 unless (page = page.to_i) && page > 1
      per_page = pager_option(:per_page, options).to_i
      options.merge! :total => self.size, :page => page, :limit => per_page
      from = (page-1) * per_page
      to = page * per_page - 1
      paginated_array = self[from..to] || []
      paginated_array.pager = DataMapper::Pager.new(options)
      paginated_array
    end
  end
end

class NuxeoService

  @options = {
    :basic_auth => {:username => Rails.application.credentials[:nuxeo_username], :password => Rails.application.credentials[:nuxeo_password]}
  }

  def self.daily_backslash_video
    params = 'app_edges_active_article=true&ecm_path=/know-edge/-backslash/&quickFilters=ProductionDate&ecm_mixinType_not_in=%5B%22HiddenInNavigation%22%5D&sortBy=The_Loupe_ProdCredits:production_date&sortOrder=desc'
    result = page_provider @options, params, 0, 10

    if result[:errorMessage].blank? && result[:entries].size > 0
      daily_backslash_video = result[:entries][0]
    else
      raise "Error fetching data from Nuxeo"
    end
  end

  def self.page_provider options, query, currentPageIndex, pageSize
    options[:headers] = {'Content-Type' => 'application/json','skipAggregates' => 'true', 'properties' => '*'}
    data = HTTParty.get("#{Settings.nuxeo_server_url}/nuxeo/api/v1/search/pp/creative_website_search/execute?currentPageIndex=#{currentPageIndex}&pageSize=#{pageSize}&#{query}", options)
    {
      entity_type: data['entity-type'],
      resultsCount: data['resultsCount'],
      pageSize: data['pageSize'],
      currentPageSize: data['currentPageSize'],
      currentPageIndex: data['currentPageIndex'],
      numberOfPages: data['numberOfPages'],
      isPreviousPageAvailable: data['isPreviousPageAvailable'],
      isNextPageAvailable: data['isNextPageAvailable'],
      isLastPageAvailable: data['isLastPageAvailable'],
      errorMessage: data['errorMessage'],
      entries: data['entries'],
    }
  end

end

class IndeedController < ApplicationController
  def index 
    @cities = ["Paris", "Lyon", "Nice", "Strasbourg", "Bordeaux", "Rennes", "Saint-Etienne", "Toulon", "Villeurbanne", "Angers", "Limoges", "Clermont-Ferrand", "Aix-en-Provence", "Amiens", "Metz", "Besancon", "Rouen", "Nancy", "Caen", "Argenteuil", "Tourcoing", "Dunkerque", "Avignon", "Poitiers", "Vitry-sur-Seine"]
  end

  def manage
    require 'uri'
    if session[:count] != nil
      if session[:count] <= 3
        search = URI.escape params[:keyword].split(" ").join("+")
        session[:count] = session[:count] + 1
        redirect_to to_excel_path(search, params[:city], format: :xlsx)
      else
        redirect_to end_trying_path
      end
    else
      search = URI.escape params[:keyword].split(" ").join("+")
      session[:count] = 1
      redirect_to to_excel_path(search, params[:city], format: :xlsx)
    end
  end

  def game_over
  end

  def to_excel
    @results = [] 
    @cities = ["Paris", "Lyon", "Nice", "Strasbourg", "Bordeaux", "Rennes", "Saint-Etienne", "Toulon", "Villeurbanne", "Angers", "Limoges", "Clermont-Ferrand", "Aix-en-Provence", "Amiens", "Metz", "Besancon", "Rouen", "Nancy", "Caen", "Argenteuil", "Tourcoing", "Dunkerque", "Avignon", "Poitiers", "Vitry-sur-Seine"]
    # @cities.each do |city|
    #   c = get_result_content_from_indeed(city)
    #   c.each do |r|
    #     @results.push(r)
    #   end
    # end
    @results = get_result_content_from_indeed(params[:keyword],params[:city])
    respond_to do |format|
      format.xlsx {
        render xlsx: 'indeed', filename: "indeed.xlsx"
      }
      format.html { render :index }
    end
  end

  def get_result_content_from_indeed(search,city)
    require 'open-uri'
    pages = ["10","20","30","40","50","60","70","80","90","100","110","120","130","120","130","140","150","160","170","180","190","200","210","220","230","220","230","240","250","260","270","280","290","300","310","320","330","320","330","340","350","360","370","380","390","400","410","420","430","420","430","440","450","460","470","480","490","500"]
    query = search
    results = []
    titles = []
    enterprises = []
    regions = []
    descriptions = []
    links = []
    releases = []
    doc = Nokogiri::HTML(open("https://www.indeed.fr/emplois?q="+query+"&l=" + city))
    i = 0
  
    get_titles = doc.css("td#resultsCol div div.title a")
    get_enterprises = doc.css("td#resultsCol div.sjcl span.company")
    get_regions = doc.css("td#resultsCol div.sjcl span.location")
    get_descriptions = doc.css("td#resultsCol div.summary")
    get_links = doc.css("td#resultsCol div div.title a")
    get_releases = doc.css("td#resultsCol div.result-link-bar span.date")
  
    get_titles.each do |title|
      titles.push(title.content[13..-1])
    end
  
    get_enterprises.each do |e|
      enterprises.push(e.content.delete("\n").delete(" "))
    end
  
    get_regions.each do |r|
      regions.push(r.content)
    end
  
    get_descriptions.each do |d|
      descriptions.push(d.content[13..-1])
    end  

    get_links.each do |link| 
      if link['href'][-29] == "&"
        links.push("https://www.indeed.fr/viewjob?jk=" + link['href'][-45..-1])
      else
        links.push("https://www.indeed.fr/viewjob?jk=" + link['href'][-45..-30] + "&" + link['href'][-28..-1])
      end
    end

    get_releases.each do |r|
      releases.push(r.content)
    end
  
    titles.each do |t|
      results.push({
        :keyword => search,
        :title => t, 
        :enterprise => enterprises[i], 
        :region => regions[i], 
        :description => descriptions[i], 
        :url => links[i],
        :release => releases[i]
      })
      i = i + 1
    end
  
    pages.each do |p|
      titles = []
      enterprises = []
      regions = []
      descriptions = []
      links = []
      releases = []
      doc = Nokogiri::HTML(open("https://www.indeed.fr/emplois?q="+query+"&l=" + city + "&start="+ p))
      i = 0
      get_titles = doc.css("td#resultsCol div div.title a")
      get_enterprises = doc.css("td#resultsCol div.sjcl span.company")
      get_regions = doc.css("td#resultsCol div.sjcl span.location")
      get_descriptions = doc.css("td#resultsCol div.summary")
      get_links = doc.css("td#resultsCol div div.title a")
      get_releases = doc.css("td#resultsCol div.result-link-bar span.date")
  
      get_titles.each do |title|
        titles.push(title.content[13..-1])
      end
  
      get_enterprises.each do |e|
        enterprises.push(e.content.delete("\n").delete(" "))
      end
  
      get_regions.each do |r|
        regions.push(r.content)
      end
  
      get_descriptions.each do |d|
        descriptions.push(d.content[13..-1])
      end 
      
      get_links.each do |link| 
        if link['href'][-29] == "&"
          links.push("https://www.indeed.fr/viewjob?jk=" + link['href'][-45..-1])
        else
          links.push("https://www.indeed.fr/viewjob?jk=" + link['href'][-45..-30] + "&" + link['href'][-28..-1])
        end
      end

      get_releases.each do |r|
        releases.push(r.content)
      end
  
      titles.each do |t|
        results.push({
          :keyword => search,
          :title => t, 
          :enterprise => enterprises[i], 
          :region => regions[i], 
          :description => descriptions[i], 
          :url => links[i],
          :release => releases[i]
        })
        i = i + 1
      end
    end
  
    results
  end

end

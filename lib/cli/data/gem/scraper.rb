class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    flatiron_profiles = Nokogiri::HTML(html)
    
    profiles = []
   
    flatiron_profiles.css("div.student-card").each do |profile|
      profile_hash = {:name => nil, :location => nil, :profile_url => nil}
      profile_hash[:name] = profile.css("h4.student-name").text
      profile_hash[:location] = profile.css("p.student-location").text
      profile_hash[:profile_url] = profile.css("a").attribute("href").value
      profiles << profile_hash
    end
    
    profiles
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    profile_page = Nokogiri::HTML(html)
    
    user_profile = {}
   
    social_links = profile_page.css("div.social-icon-container").css("a").collect do |site|
      site["href"]
    end
    
    social_links.each do |social_link|
      if social_link.scan(/\w+/)[1] != "www"
        site = social_link.scan(/\w+/)[1].to_sym
      else
        site = social_link.scan(/\w+/)[2].to_sym
      end
      if [:twitter, :linkedin, :github].include?(site)
        user_profile[site] = social_link
      else
        user_profile[:blog] = social_link
      end
    end
    
    user_profile[:profile_quote] = profile_page.css("div.profile-quote").text
    user_profile[:bio] = profile_page.css("div.bio-block.details-block").css("div.description-holder").text.strip

    user_profile
  end
end
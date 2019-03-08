require_relative '../config/environment'

API_URL = "https://www.episodate.com/api/"


# (prevent text clutter + spacing with empty puts lines)


class CLI
  attr_accessor :user, :title_search, :menu_message, :thesaurus


  def self.run
    @thesaurus = Thesaurus.new
    self.welcome_message
  end


## ========== WELCOME PAGE (TOP) ========== ##
  def self.welcome_message
    system('clear')
    Ascii.welcome_page_ascii
    puts "Welcome to the Show Randomizer!
-------------------------------
Here, you can select your favorite shows
and generate playlists of random episodes
from your favorites!"
    puts
    self.user_select
  end


## ========== WELCOME PAGE (BOTTOM) ========== ##
  def self.user_select
    puts "
(NOTE: Usernames are case sensitive)
Please enter a user name, or enter a blank name
to see a list of all users:
"
    user_input = STDIN.gets.chomp
    if user_input.strip == ""
      list_all_users("user_select_menu")
    else
      self.create_or_load_profile(user_input)
    end
  end


  def self.create_or_load_profile(user_input)
    user_profile = User.find_by(name: user_input)
    if user_profile == nil
      @user = User.create(name: user_input)
    else
      @user = user_profile
    end
    self.main_menu
  end


## ========== USER MAIN MENU (DISPLAY)========== ##
  def self.main_menu
    system('clear')
    puts @menu_message
    puts "
Welcome #{@user.name}!
Please select an option below:


1. Search shows by title
2. Show current list of favorite shows
3. Generate playlist!
4. Select different user
5. Print all user names
6. View your user profile
7. View program statistics

0. Quit program"

    puts
    user_input = STDIN.gets.chomp
    self.route_user_input(user_input)
  end


## ========== USER MAIN MENU (BACKEND)========== ##
  def self.route_user_input(user_input)
    if user_input == "1" || @thesaurus.main_menu_1_words.include?(user_input.downcase)
      @menu_message = nil
      self.search_shows_by_title
    elsif user_input == "2" || @thesaurus.main_menu_2_words.include?(user_input.downcase)
       @menu_message = nil
      print_list_of_favorites(@user, "main_menu")     #<~~ Goes to Line 29 - api_helper_method.rb
    elsif user_input == "3" || @thesaurus.main_menu_3_words.include?(user_input.downcase)
      @menu_message = nil
      puts
      puts "Loading episodes, please wait..."
      fetch_episodes_for_playlist(@user)
    elsif user_input == "4" || @thesaurus.main_menu_4_words.include?(user_input.downcase)
      @menu_message = nil
      self.welcome_message
    elsif user_input == "5" || @thesaurus.main_menu_5_words.include?(user_input.downcase)
      list_all_users("main_menu")
    elsif user_input == "6" || @thesaurus.main_menu_6_words.include?(user_input.downcase)
      puts
      puts "Profile loading, please wait..."
      user_profile_menu(@user)
    elsif user_input == "7" || @thesaurus.main_menu_7_words.include?(user_input.downcase)
      view_program_statistics
    elsif user_input == "0" || @thesaurus.main_menu_0_words.include?(user_input.downcase)
      self.goodbye_message
    else
      @menu_message = "Invalid input. Please try again:"
      self.main_menu
    end
  end


  def self.goodbye_message
      system('clear')
      Ascii.goodbye_art
      puts "Thank you! Goodbye!"
      puts
      puts
      puts
      puts
      exit
  end


## ========== OPTION 1. FROM USER MAIN MENU ========== ##
  def self.search_shows_by_title
    system('clear')
    puts @menu_message
    puts "Enter show title to search \nor hit enter to return to main menu:"
    @title_search = STDIN.gets.chomp
    if @title_search.strip == ""
      @menu_message = nil
      self.main_menu
    else
      url = API_URL + "search?q=" + @title_search
      url.gsub!(" ", "%20")
      json = get_json(url) #=> receive Hash of search-result
      self.get_array_of_tv_shows(json)
    end
  end


  def self.get_array_of_tv_shows(json)
    all_pages = []
    if json["pages"] == 1
      all_pages = json["tv_shows"]
      @menu_message = nil
    elsif json["pages"] > 1
      @menu_message = nil
      counter = json["page"]
      counter_max = json["pages"]
      while counter <= counter_max
        url = API_URL + "search?q=" + @title_search + "&page=" + counter.to_s
        json = get_json(url)
        all_pages += json["tv_shows"]
        counter += 1
      end
      all_pages

    elsif json["pages"] == 0
      @menu_message = "No results found, please search again."
      self.search_shows_by_title

    else
      puts "ERROR: json[\"pages\"] returned a non-zero, non-positive number"
      puts "Returning to self.search_shows_by_title CLI class method."
      self.search_shows_by_title
    end
    search_results(all_pages)
  end



  def self.select_id_from_results(formatted_list)
    puts "Please enter the id number for the show you are looking for \nor hit enter to return to main menu:"
    user_input = STDIN.gets.chomp
    formatted_list.each do |string|
      if user_input.strip == ""
        @menu_message = nil
        self.main_menu
      elsif string.include?(user_input)
        url = API_URL + "show-details?q=" + user_input.to_s
        show_hash = get_json(url)["tvShow"] #=> hash of ONLY THE SPECIFIC show's details
        @menu_message = nil
        self.display_found_show_details(show_hash)
      end
    end
    @menu_message = "ID not found. Please enter a valid ID"
    self.print_search_results(formatted_list)
  end


## ========== RESULTS PAGE (DISPLAY)========== ##
  def self.print_search_results(formatted_list)
    system('clear')
    puts @menu_message
    puts
    puts "Search results (total count: #{formatted_list.count})"
    puts "=================================="
    puts formatted_list
    puts
    self.select_id_from_results(formatted_list)
  end


## ========== SHOW DETAILS PAGE (DISPLAY)========== ##
  def self.display_found_show_details(show_hash)
    seasons = season_list(show_hash)
    system('clear')
    puts @menu_message
    puts "
You have selected:
==================
Title: #{show_hash["name"]}
Genre: #{show_hash["genres"][0]}
Air Date: #{show_hash["start_date"]}
Network: #{show_hash["network"]}
Seasons: #{seasons.count}

Description: \n#{show_hash["description"]}".gsub(/<br\s*\/?>/, '').gsub(/<b\s*\/?>/, '').gsub(/\<\/b>/, '').gsub(/<i\s*\/?>/, '').gsub(/\<\/i>/, '').gsub(/<strong\s*\/?>/, '').gsub(/\<\/strong>/, '')
    # currently only displays first genre (in array)
    # .gsub stuff: Scrub HTML tags from description
    puts
    puts "
What would you like to do?
1. Add to Favorites
2. View list of seasons/episodes
3. Search for another title
4. Back to main menu

0. Quit program

"
    user_input = STDIN.gets.chomp
    self.what_would_you_like_to_do(user_input, show_hash)
  end

## ========== SHOW DETAILS PAGE (BACKEND) ========== ##
  def self.what_would_you_like_to_do(user_input, show_hash)
    if user_input == "1" || @thesaurus.display_menu_1_words.include?(user_input.downcase)
      self.add_to_favorites(show_hash)
    elsif user_input == "2" || @thesaurus.display_menu_2_words.include?(user_input.downcase)
      @menu_message = nil
      display_seasons(show_hash)
    elsif user_input == "3" || @thesaurus.display_menu_3_words.include?(user_input.downcase)
      @menu_message = nil
      self.search_shows_by_title
    elsif user_input == "4" || @thesaurus.display_menu_4_words.include?(user_input.downcase)
      @menu_message = nil
      self.main_menu
    elsif user_input == "0" || @thesaurus.display_menu_0_words.include?(user_input.downcase)
      self.goodbye_message
    else
      @menu_message = "Please enter a valid option"
      self.display_found_show_details(show_hash)
    end
  end


## ========== OPTION 1. FROM SHOW DETAILS ========== ##
  def self.add_to_favorites(show_hash)
   favorite_show = Favorite.find_by(user_id: @user.id, show_id: show_hash["id"])

   if favorite_show == nil
     Favorite.create(user_id: @user.id, show_id: show_hash["id"], playlist_on_off: "on")
     @menu_message = "#{show_hash["name"]} has been added to your favorites!"
     add_show_to_table(show_hash)
     self.display_found_show_details(show_hash)
   else
     @menu_message = "#{show_hash["name"]} is already in your favorites!"
     self.display_found_show_details(show_hash)
   end
  end



  def self.season_list(show_hash)
    season_array = []
    show_hash["episodes"].each do |episode|
      season_array << "Season #{episode["season"]}"
    end
    season_array.uniq
  end



  def self.display_seasons(show_hash)
    system('clear')
    puts @menu_message
    seasons = season_list(show_hash)
    puts "List of Seasons:"
    puts "================"
    puts seasons
    puts
    puts "Please enter a season number to view list of episodes"
    puts "or Enter to go back"
    user_input = STDIN.gets.chomp
    if user_input == ""
      @menu_message = nil
      display_found_show_details(show_hash)
    else
      selection = seasons.select do |season|
        season.include?(user_input)
      end
      if selection.count == 0
        @menu_message = "Please enter a valid season number"
        display_seasons(show_hash)
      else
        display_episode_list(user_input, show_hash)
      end
    end
  end



  def self.display_episode_list(user_input, show_hash)
    @menu_message = nil
    episode_array = []
    show_hash["episodes"].each do |episode|
      if episode["season"] == user_input.to_i
        new_string = "Episode #{episode['episode']}. #{episode['name']}"
        episode_array << new_string
      end
    end
    system('clear')
    puts "Season #{user_input}"
    puts "===================="
    puts episode_array
    puts
    puts "Press enter to go back"
    STDIN.gets.chomp
    display_seasons(show_hash)
  end






end

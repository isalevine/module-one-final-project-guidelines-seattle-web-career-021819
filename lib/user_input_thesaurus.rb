# list of synonyms for user_input

class Thesaurus
  attr_accessor :main_menu_1_words,
  :main_menu_2_words,
  :main_menu_3_words,
  :main_menu_4_words,
  :main_menu_5_words,
  :main_menu_6_words,
  :main_menu_7_words,
  :main_menu_0_words,

  :display_menu_1_words,
  :display_menu_2_words,
  :display_menu_3_words,
  :display_menu_4_words,
  :display_menu_0_words,

  :profile_menu_1_words,
  :profile_menu_2_words,
  :profile_menu_3_words,
  :profile_menu_4_words,
  :profile_menu_5_words,
  :profile_menu_0_words

  def initialize
    add_syn = ["a", "ad", "add", "adding"]
    additional_syn = ["a", "ad", "add", "addi", "addit", "additional"]
    all_syn = ["a", "al", "all"]
    another_syn = ["a", "an", "another"]
    back_syn = ["b", "ba", "back"]
    change_syn = ["c", "ch", "cha", "chan", "change", "changes"]
    current_syn = ["c", "cu", "cur", "current"]
    different_syn = ["d", "di", "dif", "diff", "different"]
    episode_syn = ["e", "ep", "epi", "epis", "episode", "episodes"]
    favorite_syn = ["f", "fa", "fav", "favs", "fave", "faves", "favorite", "favorites"]
    from_syn = ["f", "fr", "fro", "from"]
    generate_syn = ["g", "ge", "gen", "generate"]
    list_syn = ["l", "li", "ls", "list"]
    main_syn = ["m", "ma", "me", "mm", "main", "menu"]
    menu_syn = ["m", "me", "men", "menu", "menus"]
    name_syn = ["n", "na", "name", "names"]
    on_syn = ["o", "on"]
    off_syn = ["o", "of", "off"]
    playlist_syn = ["p", "pl", "play", "playl", "playlist"]
    print_syn = ["p", "pr", "print"]
    profile_syn = ["p", "pr", "pro", "prof," "profile", "profiles"]
    program_syn = ["p", "pr", "pro", "prog", "program", "programs"]
    quit_syn = ["q", "qu", "quit", "e", "ex" "exit"] # Quit and Exit will both exit the program completely
    real_syn = ["r", "re", "real"]
    remove_syn = ["r", "re", "rv", "rem", "remove", "removes"]
    return_syn = ["r", "re", "ret", "return", "returns"]
    search_syn = ["s", "se", "search", "find"]
    season_syn = ["s", "se", "sea", "seas", "season", "seasons"]
    see_syn = ["s", "se", "see", "sees"]
    select_syn = ["s", "se", "sel", "select"]
    shows_syn = ["s", "h", "sh", "show", "shows"]
    statistics_syn = ["s", "st", "sta", "stat", "stats", "statistic", "statistics"]
    title_syn = ["t", "ti", "title", "titles"]
    toggle_syn = ["t", "to", "tog", "toggle", "toggles"]
    user_syn = ["u", "us", "user", "users"]
    view_syn = ["v", "vi", "vie", "view"]
    your_syn = ["y", "yo", "you", "your", "ur"]


    # NOTE: For any menu where different options have overlapping synonyms, the
    # program SHOULD proceed with the EARLIEST true statement in the if/else list


    # ==== Main Menu ==== #
    @main_menu_1_words = search_syn += title_syn

    @main_menu_2_words = shows_syn += current_syn += list_syn += favorite_syn

    @main_menu_3_words = generate_syn += playlist_syn

    @main_menu_4_words = select_syn += different_syn += user_syn

    @main_menu_5_words = print_syn += all_syn += name_syn

    @main_menu_6_words = view_syn += your_syn += profile_syn

    @main_menu_7_words = program_syn + statistics_syn

    @main_menu_0_words = quit_syn



    # ==== Display_Found_Show_Details Menu ==== #
    @display_menu_1_words = add_syn += favorite_syn

    @display_menu_2_words = view_syn += list_syn += season_syn += episode_syn

    @display_menu_3_words = search_syn += another_syn += title_syn

    @display_menu_4_words = back_syn += main_syn

    @display_menu_0_words = quit_syn


    # HOW TO MAKE THESE ATTRIBUTES AVAILABLE IN THE
    # USER PROFILE MENU??
    # ==== Display_Found_Show_Details Menu ==== #
    @profile_menu_1_words = view_syn += favorite_syn += shows_syn += toggle_syn += playlist_syn += add_syn += on_syn += off_syn

    @profile_menu_2_words = remove_syn += from_syn += list_syn

    @profile_menu_3_words = change_syn += user_syn   # name_syn included with "5. Change real name" below

    @profile_menu_4_words = real_syn += name_syn

    @profile_menu_5_words = return_syn += main_syn += menu_syn

    @profile_menu_0_words = quit_syn

  end

end

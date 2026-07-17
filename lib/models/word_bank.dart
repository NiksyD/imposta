import 'dart:math';

/// A pair containing a civilian secret word, and a list of alternative imposter descriptive hints.
class WordPair {
  final String civilianWord;
  final List<String> imposterHints;

  const WordPair(this.civilianWord, this.imposterHints);

  /// Selects a random imposter hint description from the list.
  String getRandomImposterHint(Random random) {
    if (imposterHints.isEmpty) return 'Imposter';
    return imposterHints[random.nextInt(imposterHints.length)];
  }
}

/// Available word categories.
enum WordCategory {
  everydayObjects,
  famousPeople,
  food,
  places,
  movies,
  tech,
  animals,
  brandsLogos,
  colorsShapes,
  hobbiesActivities,
  random,
}

/// Extension to give categories display names.
extension WordCategoryLabel on WordCategory {
  String get label {
    switch (this) {
      case WordCategory.everydayObjects:
        return 'Everyday Objects';
      case WordCategory.famousPeople:
        return 'Famous People';
      case WordCategory.food:
        return 'Foods & Drinks';
      case WordCategory.places:
        return 'Places';
      case WordCategory.movies:
        return 'Movies';
      case WordCategory.tech:
        return 'Tech';
      case WordCategory.animals:
        return 'Animals';
      case WordCategory.brandsLogos:
        return 'Brands & Logos';
      case WordCategory.colorsShapes:
        return 'Colors & Shapes';
      case WordCategory.hobbiesActivities:
        return 'Hobbies & Activities';
      case WordCategory.random:
        return 'Random';
    }
  }

  String get icon {
    switch (this) {
      case WordCategory.everydayObjects:
        return '🏠';
      case WordCategory.famousPeople:
        return '🦸';
      case WordCategory.food:
        return '🍕';
      case WordCategory.places:
        return '🌍';
      case WordCategory.movies:
        return '🎬';
      case WordCategory.tech:
        return '💻';
      case WordCategory.animals:
        return '🐾';
      case WordCategory.brandsLogos:
        return '🏢';
      case WordCategory.colorsShapes:
        return '🎨';
      case WordCategory.hobbiesActivities:
        return '🎯';
      case WordCategory.random:
        return '🎲';
    }
  }
}

/// The word bank containing all word pairs organized by category.
class WordBank {
  static final _random = Random();

  static const Map<WordCategory, List<WordPair>> _pairs = {
    WordCategory.everydayObjects: [
      WordPair('Plate', ['Flat', 'Kitchen', 'Tableware', 'Glazed']),
      WordPair('Key', ['Metal', 'Small', 'Pocket', 'Teeth']),
      WordPair('Mirror', ['Glass', 'Wall', 'Reflective', 'Silvered']),
      WordPair('Blanket', ['Soft', 'Heavy', 'Fabric', 'Layer']),
      WordPair('Pillow', ['Soft', 'Fluffy', 'Cushion', 'Support']),
      WordPair('Wallet', ['Pocket', 'Leather', 'Folds', 'Holder']),
      WordPair('Backpack', ['Straps', 'Zipper', 'Canvas', 'Carrier']),
      WordPair('Soap', ['Slick', 'Foam', 'Scented', 'Bar']),
      WordPair('Toothbrush', ['Bristles', 'Plastic', 'Handle', 'Bathroom']),
      WordPair('Candle', ['Wax', 'Wick', 'Melt', 'Decorative']),
      WordPair('Umbrella', ['Canopy', 'Ribs', 'Shaft', 'Folding']),
      WordPair('Clock', ['Dial', 'Ticks', 'Hands', 'Face']),
      WordPair('Spoon', ['Metal', 'Bowl-shaped', 'Utensil', 'Scoop']),
      WordPair('Cup', ['Cylindrical', 'Vessel', 'Ceramic', 'Rim']),
      WordPair('Curtain', ['Drape', 'Fabric', 'Rod', 'Hanging']),
      WordPair('Notebook', ['Ruled', 'Bound', 'Pages', 'Cover']),
    ],
    WordCategory.famousPeople: [
      WordPair('Elon Musk', ['Billionaire', 'Engineer', 'CEO', 'Tech', 'Pioneer']),
      WordPair('Albert Einstein', ['Academic', 'Scientist', 'Professor', 'Intellectual']),
      WordPair('Taylor Swift', ['Musician', 'Artist', 'Superstar', 'Celebrity']),
      WordPair('Lionel Messi', ['Athlete', 'Champion', 'Captain', 'Forward']),
      WordPair('Donald Trump', ['Politician', 'Leader', 'Businessman', 'Speaker']),
      WordPair('Michael Jackson', ['Dancer', 'Vocalist', 'Icon', 'Legend']),
      WordPair('Bill Gates', ['Founder', 'Philanthropist', 'Programmer', 'Billionaire']),
      WordPair('Leonardo DiCaprio', ['Actor', 'Star', 'Producer', 'Performer']),
      WordPair('Beyoncé', ['Diva', 'Vocalist', 'Performer', 'Star']),
      WordPair('Spider-Man', ['Vigilante', 'Hero', 'Webbed', 'Teenager']),
      WordPair('Marilyn Monroe', ['Model', 'Actress', 'Icon', 'Starlet']),
    ],
    WordCategory.food: [
      WordPair('Apple', ['Flesh', 'Skin', 'Core', 'Orchard', 'Crisp']),
      WordPair('Pineapple', ['Tropical', 'Spiky', 'Fleshy', 'Crown', 'Sweet']),
      WordPair('Pizza', ['Baked', 'Crust', 'Toppings', 'Dough', 'Flat']),
      WordPair('Sushi', ['Raw', 'Rolled', 'Seaweed', 'Vinegared', 'Bite-sized']),
      WordPair('Cake', ['Layered', 'Sweet', 'Frosted', 'Baked', 'Sponge']),
      WordPair('Coffee', ['Brewed', 'Roasted', 'Bitter', 'Hot', 'Morning']),
      WordPair('Chocolate', ['Cocoa', 'Sweet', 'Brown', 'Confectionery', 'Bar']),
      WordPair('Bread', ['Loaf', 'Baked', 'Crusty', 'Slices', 'Wheat']),
      WordPair('Rice', ['Grain', 'Steamed', 'Staple', 'White', 'Field']),
      WordPair('Butter', ['Dairy', 'Churned', 'Spread', 'Yellow', 'Fat']),
      WordPair('Steak', ['Grilled', 'Beef', 'Sear', 'Meat', 'Cut']),
      WordPair('Pancake', ['Flat', 'Griddled', 'Batter', 'Round', 'Stack']),
      WordPair('Ketchup', ['Tomato', 'Condiment', 'Sauce', 'Red', 'Bottle']),
      WordPair('Ice Cream', ['Frozen', 'Sweet', 'Dairy', 'Scooped', 'Creamy']),
      WordPair('Taco', ['Folded', 'Shell', 'Filled', 'Mexican', 'Crispy']),
      WordPair('Bacon', ['Cured', 'Pork', 'Strips', 'Salty', 'Crispy']),
      WordPair('Soup', ['Broth', 'Liquid', 'Hot', 'Savory', 'Bowl']),
      WordPair('Cookie', ['Sweet', 'Baked', 'Crisp', 'Bite-sized']),
      WordPair('Mango', ['Tropical', 'Sweet', 'Stone-fruit', 'Orange-flesh']),
      WordPair('Lemon', ['Sour', 'Citrus', 'Yellow', 'Acidic', 'Juice']),
    ],
    WordCategory.places: [
      WordPair('Paris', ['Capital', 'European', 'Metropolis', 'City']),
      WordPair('Beach', ['Sandy', 'Coastal', 'Shoreline', 'Waterfront']),
      WordPair('Mountain', ['Peak', 'Elevation', 'Rocky', 'Summit', 'Slope']),
      WordPair('Library', ['Archive', 'Collection', 'Quiet', 'Study']),
      WordPair('Hospital', ['Medical', 'Facility', 'Emergency', 'Ward']),
      WordPair('Airport', ['Terminal', 'Runway', 'Transit', 'Hub']),
      WordPair('Park', ['Recreation', 'Greenery', 'Open-space', 'Lawn']),
      WordPair('Restaurant', ['Dining', 'Eatery', 'Establishment', 'Menu']),
      WordPair('School', ['Academy', 'Classrooms', 'Education', 'Institute']),
      WordPair('Church', ['Sanctuary', 'Spire', 'Altar', 'Sacred']),
      WordPair('Stadium', ['Arena', 'Coliseum', 'Stands', 'Grandstand']),
      WordPair('Desert', ['Arid', 'Dunes', 'Barren', 'Dry']),
      WordPair('Island', ['Landmass', 'Coastline', 'Isolated', 'Offshore']),
      WordPair('Tokyo', ['Asian', 'Megacity', 'Capital', 'Urban']),
      WordPair('Castle', ['Fortress', 'Stone', 'Moat', 'Keep']),
      WordPair('Cinema', ['Theater', 'Screening', 'Auditorium', 'Hall']),
      WordPair('Hotel', ['Lodging', 'Rooms', 'Suite', 'Stay']),
    ],
    WordCategory.movies: [
      WordPair('Batman', ['Vigilante', 'Caped', 'Crusader', 'Masked']),
      WordPair('Titanic', ['Vessel', 'Voyage', 'Historic', 'Tragedy']),
      WordPair('Star Wars', ['Sci-fi', 'Saga', 'Space', 'Galactic']),
      WordPair('Harry Potter', ['Wizarding', 'Saga', 'Magical', 'Orphan']),
      WordPair('Frozen', ['Animated', 'Disney', 'Snowy', 'Sisters']),
      WordPair('Finding Nemo', ['Animated', 'Oceanic', 'Undersea', 'Lost']),
      WordPair('Toy Story', ['Animated', 'Playroom', 'Childhood', 'Living']),
      WordPair('The Lion King', ['Savanna', 'Pridelands', 'Kingdom', 'Animated']),
      WordPair('Shrek', ['Fairytale', 'Animated', 'Green', 'Swamp']),
      WordPair('Fast & Furious', ['Action', 'Cars', 'Speed', 'Franchise']),
      WordPair('Joker', ['Villain', 'Clown', 'Gotham', 'Deranged']),
      WordPair('Matrix', ['Sci-fi', 'Simulation', 'Virtual', 'Dystopian']),
      WordPair('Rocky', ['Fighter', 'Athlete', 'Underdog', 'Champion']),
      WordPair('Alien', ['Sci-fi', 'Monster', 'Spacecraft', 'Hostile']),
      WordPair('Godzilla', ['Monster', 'Giant', 'Radioactive', 'Japan']),
    ],
    WordCategory.tech: [
      WordPair('iPhone', ['Device', 'Smartphone', 'Mobile', 'Touchscreen']),
      WordPair('Google', ['Search-engine', 'Website', 'Portal', 'Internet']),
      WordPair('Laptop', ['Computer', 'Portable', 'Screen', 'Keyboard']),
      WordPair('Wi-Fi', ['Network', 'Wireless', 'Signal', 'Frequency']),
      WordPair('Instagram', ['Platform', 'Feed', 'Profiles', 'Photos']),
      WordPair('Netflix', ['Streaming', 'Platform', 'Subscription', 'Service']),
      WordPair('Windows', ['Operating-system', 'Software', 'Platform', 'Desktop']),
      WordPair('Tesla', ['Automobile', 'Electric', 'Vehicles', 'Battery']),
      WordPair('Alexa', ['Assistant', 'Smart-speaker', 'Voice-controlled']),
      WordPair('Chrome', ['Browser', 'Software', 'Google', 'Web']),
      WordPair('Keyboard', ['Keys', 'Input-device', 'Peripheral', 'Board']),
      WordPair('Drone', ['Quadcopter', 'Aircraft', 'Camera-rig', 'Remote']),
      WordPair('PlayStation', ['Console', 'Gaming', 'Device', 'Controller']),
      WordPair('Twitter', ['Platform', 'Microblogging', 'Feed', 'App']),
    ],
    WordCategory.animals: [
      WordPair('Dog', ['Canine', 'Pet', 'Domestic', 'Mammal']),
      WordPair('Cat', ['Feline', 'Pet', 'Domestic', 'Carnivore']),
      WordPair('Horse', ['Equine', 'Domestic', 'Hoofed', 'Herbivore']),
      WordPair('Dolphin', ['Marine', 'Mammal', 'Aquatic', 'Pod']),
      WordPair('Eagle', ['Raptor', 'Predator', 'Avian', 'Wings']),
      WordPair('Frog', ['Amphibian', 'Pond', 'Webbed-feet', 'Leaping']),
      WordPair('Rabbit', ['Mammal', 'Burrowing', 'Long-eared', 'Fur']),
      WordPair('Crocodile', ['Reptile', 'Predator', 'Aquatic', 'Scales']),
      WordPair('Bee', ['Insect', 'Stinger', 'Social', 'Colony']),
      WordPair('Monkey', ['Primate', 'Mammal', 'Forest', 'Tree-dwelling']),
      WordPair('Seal', ['Marine', 'Mammal', 'Flippers', 'Aquatic']),
      WordPair('Deer', ['Forest', 'Hoofed', 'Mammal', 'Herbivore']),
      WordPair('Turtle', ['Reptile', 'Carapace', 'Shell', 'Aquatic']),
      WordPair('Lion', ['Predator', 'Feline', 'Roaring', 'Mammal']),
      WordPair('Camel', ['Mammal', 'Desert', 'Hoofed', 'Beast']),
    ],
    WordCategory.brandsLogos: [
      WordPair('Nike', ['Athletic', 'Apparel', 'Footwear', 'Swoosh']),
      WordPair('McDonalds', ['Fast-food', 'Chain', 'Eatery', 'Burgers']),
      WordPair('Coca-Cola', ['Beverage', 'Soda', 'Can', 'Cola']),
      WordPair('Apple', ['Consumer-electronics', 'Tech', 'Brand', 'Logo']),
      WordPair('Starbucks', ['Coffeehouse', 'Chain', 'Brand', 'Beverage']),
      WordPair('Toyota', ['Automotive', 'Manufacturer', 'Brand', 'Cars']),
      WordPair('Google', ['Tech', 'Search', 'Brand', 'Web']),
      WordPair('Netflix', ['Streaming', 'Service', 'Brand', 'Entertainment']),
      WordPair('Ferrari', ['Luxury', 'Automotive', 'Brand', 'Supercar']),
    ],
    WordCategory.colorsShapes: [
      WordPair('Red', ['Hue', 'Primary', 'Color', 'Warm']),
      WordPair('Blue', ['Hue', 'Primary', 'Color', 'Cool']),
      WordPair('Circle', ['Geometric', 'Shape', 'Curved', 'Round']),
      WordPair('Square', ['Geometric', 'Shape', 'Corners', 'Equilateral']),
      WordPair('Purple', ['Hue', 'Secondary', 'Color', 'Shade']),
      WordPair('Black', ['Shade', 'Dark', 'Colorless', 'Absorbing']),
      WordPair('Gold', ['Metallic', 'Color', 'Shiny', 'Valuable']),
    ],
    WordCategory.hobbiesActivities: [
      WordPair('Football', ['Athletic', 'Sport', 'Team-game', 'Match']),
      WordPair('Running', ['Cardio', 'Exercise', 'Sprint', 'Acrobatic']),
      WordPair('Reading', ['Intellectual', 'Leisure', 'Literary', 'Study']),
      WordPair('Painting', ['Artistic', 'Creative', 'Medium', 'Expression']),
      WordPair('Cooking', ['Culinary', 'Kitchen', 'Preparation', 'Meal']),
      WordPair('Hiking', ['Outdoor', 'Trail', 'Excursion', 'Trekking']),
      WordPair('Chess', ['Strategic', 'Board-game', 'Turn-based', 'Match']),
      WordPair('Singing', ['Vocal', 'Musical', 'Performance', 'Melodic']),
      WordPair('Guitar', ['Stringed', 'Instrument', 'Acoustic', 'Chords']),
    ],
  };

  /// Get a random word pair from the specified category.
  /// If [WordCategory.random], picks from all categories.
  static WordPair getRandomPair(WordCategory category) {
    if (category == WordCategory.random) {
      // Pick from all non-random categories
      final allCategories = WordCategory.values
          .where((c) => c != WordCategory.random)
          .toList();
      final randomCategory =
          allCategories[_random.nextInt(allCategories.length)];
      final pairs = _pairs[randomCategory]!;
      return pairs[_random.nextInt(pairs.length)];
    }

    final pairs = _pairs[category]!;
    return pairs[_random.nextInt(pairs.length)];
  }

  /// Get all pairs for a category (for browsing / custom selection).
  static List<WordPair> getPairs(WordCategory category) {
    if (category == WordCategory.random) {
      return _pairs.values.expand((list) => list).toList();
    }
    return _pairs[category] ?? [];
  }
}

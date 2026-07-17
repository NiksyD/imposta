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
      WordPair('Mirror', ['Glass', 'Wall', 'Clone', 'Silvered']),
      WordPair('Blanket', ['Soft', 'Warm', 'Fabric', 'Layer']),
      WordPair('Pillow', ['Soft', 'Fluffy', 'Head', 'Support']),
      WordPair('Wallet', ['Pocket', 'Leather', 'Folds', 'Holder']),
      WordPair('Backpack', ['Straps', 'Zipper', 'Pack', 'Carry']),
      WordPair('Soap', ['Slick', 'Foam', 'Scented', 'Bar']),
      WordPair('Toothbrush', ['Bristles', 'Plastic', 'Handle', 'Bathroom']),
      WordPair('Candle', ['Wax', 'Flame', 'Melt', 'Light']),
      WordPair('Umbrella', ['Shield', 'Cover', 'Dome', 'Folding']),
      WordPair('Clock', ['Dial', 'Ticks', 'Hands', 'Face']),
      WordPair('Spoon', ['Metal', 'Curved', 'Stirring', 'Tableware']),
      WordPair('Cup', ['Cylindrical', 'Vessel', 'Handle', 'Hot']),
      WordPair('Curtain', ['Drape', 'Fabric', 'Window', 'Hanging']),
      WordPair('Notebook', ['Ruled', 'Lines', 'Pages', 'Cover']),
      WordPair('Stapler', ['Metal', 'Clamp', 'Papers', 'Office']),
      WordPair('Scissors', ['Blades', 'Cut', 'Handles', 'Pointed']),
      WordPair('Calculator', ['Buttons', 'Display', 'Math', 'Numbers']),
      WordPair('Flashlight', ['Beam', 'Light', 'Button', 'Portable']),
      WordPair('Tissues', ['Soft', 'Absorbent', 'Pack', 'Paper']),
      WordPair('Mouse', ['Click', 'Sensor', 'Scroll', 'Digital']),
      WordPair('Keyboard', ['Keys', 'Space', 'Enter', 'Numbers']),
      WordPair('Monitor', ['Screen', 'Display', 'View', 'Tech']),
      WordPair('Headphones', ['Ears', 'Audio', 'Wires', 'Music']),
      WordPair('Charger', ['Cable', 'Power', 'Connector', 'Electric']),
      WordPair('Jar', ['Glass', 'Lid', 'Container', 'Peanut']),
      WordPair('Bottle', ['Glass', 'Lid', 'Container', 'Liquid']),
      WordPair('Glass', ['Drinking', 'Vessel', 'Transparent', 'Handle']),
      WordPair('Pen', ['Hand', 'Ink', 'Tip', 'Cap']),
      WordPair('Book', ['Paper', 'Cover', 'Stories', 'Chapter']),
      WordPair('Bag', ['Carry', 'Zipper', 'Straps', 'Pocket']),
      WordPair('Phone', ['Screen', 'Apps', 'Call', 'Message']),
      WordPair('Computer', ['Screen', 'Robot', 'Data', 'Program']),
      WordPair('Tablet', ['Screen', 'Touch', 'Medicine', 'Doctor']),
      WordPair('Watch', ['Look', 'Wall', 'Time', 'Hands']),
      WordPair('Jewelry', ['Silver', 'Gold', 'Rings', 'Shiny']),
      WordPair('Camera', ['Lens', 'Click', 'Zoom', 'Image']),
    ],
    WordCategory.famousPeople: [
      WordPair('Elon Musk', ['Billionaire', 'Engineer', 'CEO', 'Space', 'Tech']),
      WordPair('Albert Einstein', ['Bald', 'Science', 'Genius', 'Physics']),
      WordPair('Taylor Swift', ['Guitar', 'Artist', 'Pop', 'Celebrity']),
      WordPair('Lionel Messi', ['Athlete', 'Champion', 'Football', 'Dribble']),
      WordPair('Donald Trump', ['Hair', 'Leader', 'Television', 'Freedom']),
      WordPair('Michael Jackson', ['Beat', 'Vocalist', 'Icon', 'Legend']),
      WordPair('Bill Gates', ['IQ', 'Windows', 'Programmer', 'Billionaire']),
      WordPair('Leonardo DiCaprio', ['Wolf', 'Star', 'Producer', 'Sales']),
      WordPair('Beyoncé', ['Diva', 'Vocalist', 'Performer', 'Star']),
      WordPair('Spider-Man', ['Friendly', 'Hero', 'Web', 'Teenager']),
      WordPair('Bob Marley', ['One Love', 'Curly', 'Cannabis leaf', 'Reggae']),
      WordPair('Optimus Prime', ['Robot', 'Transform', 'Truck', 'Hero']),
      WordPair('IShowSpeed', ['FIFA', 'Twitch', 'Fast', 'Backflip']),
       // NATIONAL HEROES & HISTORY
      WordPair('Jose Rizal', ['Hero', 'Peso', 'Doctor', 'Martyr']),
      WordPair('Andres Bonifacio', ['Hero', 'Leader', 'Revolutionary', 'Supreme']),
      WordPair('Lapu-Lapu', ['Warrior', 'Chief', 'Hero', 'Sword']),
      WordPair('BBM', ['Leader', 'Corruption', 'Stutter', 'Thief']),

      // ATHLETES & SPORTS
      WordPair('Manny Pacquiao', ['Division', 'Senate', 'Champion', 'Legend']),
      WordPair('Hidilyn Diaz', ['Athlete', 'Olympian', 'Strong', 'Gold']),
      WordPair('Carlos Yulo', ['Gymnast', 'Flip', 'Athlete', 'Champion']),
      WordPair('Efren "Bata" Reyes', ['Player', 'Legend', 'Magician', 'Winner']),
      WordPair('Jaybee Sucal', ['Pool', 'Billiard', 'Jumper', '8 ball']),
      WordPair('Ivana Alawi', ['iPhone', 'Model', 'Top', 'Partners in Crime']),

      // SHOWBIZ & ENTERTAINMENT
      WordPair('Vice Ganda', ['Comedy', 'Host', 'Star', 'Wig']),
      WordPair('Sarah Geronimo', ['Singer', 'Voice', 'Performer', 'Idol']),
      WordPair('Kathryn Bernardo', ['Films', 'Star', 'Queen', 'Celebrity']),
      WordPair('Dolphy', ['Comedy', 'King', 'Legend', 'Turn around']),
      WordPair('Coco Martin', ['Immortal', 'Director', 'Action', 'Police']),
      WordPair('BINI', ['Tropical', 'Cherry on Top', 'P-Pop', 'Hits']),

      // WORLD CLASS ICONS
      WordPair('Lea Salonga', ['Reflection', 'Broadway', 'Voice', 'Disney']),
      WordPair('Catriona Gray', ['Beauty', 'Universe', 'Model', 'Host']),
      WordPair('Pia Wurtzbach', ['Queen', 'Universe', 'Actress', 'Model']),
      WordPair('Apo Whang-Od', ['Old Tattoo', 'Legend', 'Tattoo', 'Elder']),
    ],
    WordCategory.food: [
      WordPair('Apple', ['Flesh', 'Skin', 'Phone', 'Crisp']),
      WordPair('Pineapple', ['Tropical', 'Spiky', 'Eyes', 'Crown', 'Sweet']),
      WordPair('Pizza', ['Baked', 'Cheese', 'Toppings', 'Dough', 'Flat']),
      WordPair('Sushi', ['Raw', 'Rolled', 'Seaweed', 'Vinegared', 'Japan']),
      WordPair('Cake', ['Layered', 'Frosted', 'Baked', 'Sponge', 'Sweet']),
      WordPair('Coffee', ['Brewed', 'Roasted', 'Bitter', 'Hot', 'Morning']),
      WordPair('Chocolate', ['Cocoa', 'Sweet', 'Brown', 'Confectionery', 'Bar']),
      WordPair('Bread', ['Loaf', 'Baked', 'Pan', 'Slices', 'Wheat']),
      WordPair('Rice', ['Grain', 'Steamed', 'Staple', 'White', 'Field']),
      WordPair('Butter', ['Dairy', 'Churned', 'Spread', 'Yellow', 'Fat']),
      WordPair('Steak', ['Grilled', 'Beef', 'Sear', 'Meat', 'Cut']),
      WordPair('Pancake', ['Flat', 'Griddled', 'Batter', 'Round', 'Stack']),
      WordPair('Ketchup', ['Tomato', 'Condiment', 'Sauce', 'Red', 'Bottle']),
      WordPair('Ice Cream', ['Frozen', 'Sweet', 'Dairy', 'Scooped', 'Creamy']),
      WordPair('Taco', ['Folded', 'Shell', 'Filled', 'Mexican', 'Crispy']),
      WordPair('Bacon', ['Cured', 'Pork', 'Strips', 'Salt', 'Crispy']),
      WordPair('Soup', ['Spoon', 'Liquid', 'Hot', 'Savory', 'Bowl']),
      WordPair('Cookie', ['Sweet', 'Baked', 'Crisp', 'Grandma']),
      WordPair('Mango', ['Tropical', 'Sweet', 'Stone-fruit', 'Yellow']),
      WordPair('Lemon', ['Sour', 'Citrus', 'Yellow', 'Acidic', 'Juice']),
    ],
    WordCategory.places: [
      WordPair('Paris', ['Capital', 'Europe', 'France', 'City']),
      WordPair('Beach', ['Sand', 'Coastal', 'Shoreline', 'Waterfront']),
      WordPair('Mountain', ['Peak', 'Elevation', 'Rocky', 'Summit', 'Slope']),
      WordPair('Library', ['Books', 'Collection', 'Quiet', 'Study']),
      WordPair('Hospital', ['Heal', 'Facility', 'Emergency', 'Sick']),
      WordPair('Airport', ['Terminal', 'Runway', 'Transit', 'Hub']),
      WordPair('Park', ['Recreation', 'Greenery', 'Open-space', 'Lawn']),
      WordPair('Restaurant', ['Dining', 'Eatery', 'Establishment', 'Menu']),
      WordPair('School', ['Academy', 'Board', 'Assignment', 'Institute']),
      WordPair('Church', ['Sanctuary', 'Spire', 'Altar', 'Sacred']),
      WordPair('Stadium', ['Arena', 'Coliseum', 'Stands', 'Grandstand']),
      WordPair('Desert', ['Cactus', 'Canyon', 'Hot', 'Dry']),
      WordPair('Island', ['Landmass', 'Coastline', 'Isolated', 'Offshore']),
      WordPair('Tokyo', ['PlayStation', 'Megacity', 'Capital', 'Uniqlo']),
      WordPair('Castle', ['Fortress', 'Stone', 'Bricks', 'Medieval']),
      WordPair('Cinema', ['Theater', 'Screening', 'Auditorium', 'Hall']),
      WordPair('Hotel', ['Lodge', 'Rooms', 'Suite', 'Stay']),
    ],
    WordCategory.movies: [
      WordPair('Batman', ['Vigilante', 'Caped', 'Crusader', 'Masked']),
      WordPair('Titanic', ['Vessel', 'Voyage', 'Historic', 'Tragedy']),
      WordPair('Star Wars', ['Saber', 'Fantasy', 'Space', 'Galactic']),
      WordPair('Harry Potter', ['Wizard', 'Saga', 'Magical', 'Orphan']),
      WordPair('Frozen', ['Animated', 'Disney', 'Snowy', 'Sisters']),
      WordPair('Finding Nemo', ['Fish', 'Ocean', 'Marlin', 'Lost']),
      WordPair('Toy Story', ['Andy', 'Playroom', 'Buzz', 'Toys']),
      WordPair('The Lion King', ['Savanna', 'Circle of Life', 'African Animals', 'Big Cats']),
      WordPair('Shrek', ['Donkey', 'Far Far Away', 'Green', 'Swamp']),
      WordPair('Fast & Furious', ['Diesel', 'Cars', 'Speed', 'Muscle Cars']),
      WordPair('Joker', ['Villain', 'Clown', 'Laughing', 'Card']),
      WordPair('Godzilla', ['Monster', 'Giant', 'Radioactive', 'Dinosaur']),
    ],
    WordCategory.tech: [
      WordPair('iPhone', ['Device', 'Smartphone', 'Mobile', 'Touchscreen']),
      WordPair('Google', ['Search-engine', 'Website', 'Portal', 'Internet']),
      WordPair('Laptop', ['Computer', 'Portable', 'Screen', 'Keyboard']),
      WordPair('Wi-Fi', ['Network', 'Data', 'Signal', 'Frequency']),
      WordPair('Netflix', ['Streaming', 'Movies', 'Shows', 'Series']),
      WordPair('Windows', ['Glass', 'Software', 'Clear', 'View']),
      WordPair('Tesla', ['Battery', 'Electric', 'Vehicles', 'Musk']),
      WordPair('Drone', ['Fly', 'Aircraft', 'Camera-rig', 'Remote']),
      WordPair('PlayStation', ['Console', 'Gaming', 'Device', 'Controller']),
    ],
    WordCategory.animals: [
      WordPair('Dog', ['Fetch', 'Pet', 'Bone', 'Loyal']),
      WordPair('Cat', ['Tom', 'Pet', 'Puss', 'Yarn']),
      WordPair('Horse', ['Race', 'Rodeo', 'Saddle', 'Wheat']),
      WordPair('Dolphin', ['Dive', 'Blowhole', 'Ocean', 'Zoo']),
      WordPair('Eagle', ['Raptor', 'Predator', 'Fly', 'Wings']),
      WordPair('Frog', ['Swamp', 'Pond', 'Lilypad', 'Leaping']),
      WordPair('Rabbit', ['Leap', 'Carrot', 'Ears', 'Burrow']),
      WordPair('Bee', ['Insect', 'Sting', 'Flower', 'Honey']),
      WordPair('Monkey', ['Evolution', 'Swing', 'Forest', 'Banana']),
      WordPair('Turtle', ['Slow', 'Shell']),
      WordPair('Lion', ['Cat', 'Jungle', 'Roar', 'Savanna']),
    ],
    WordCategory.brandsLogos: [
      WordPair('Nike', ['Athletic', 'Apparel', 'Footwear', 'Swoosh']),
      WordPair('McDonalds', ['Clown', 'Restaurant', 'Burgers']),
      WordPair('Coca-Cola', ['Beverage', 'Soda', 'Can', 'Drinks']),
      WordPair('Starbucks', ['Coffeehouse', 'Coffee', 'Cafe']),
      WordPair('Toyota', ['Automotive', 'Brand', 'Cars']),
      WordPair('Google', ['Browse', 'Search', 'Web']),
      WordPair('Ferrari', ['Luxury', 'Expensive', 'Fast']),
    ],
    WordCategory.hobbiesActivities: [
      WordPair('Running', ['Cardio', 'Exercise', 'Sprint', 'Marathon']),
      WordPair('Reading', ['Literary', 'Study']),
      WordPair('Painting', ['Brush', 'Canvas', 'Creative', 'Artistic']),
      WordPair('Cooking', ['Culinary', 'Kitchen', 'Meal']),
      WordPair('Hiking', ['Trail', 'Mountain']),
      WordPair('Chess', ['Board', 'Black & White']),
      WordPair('Guitar', ['String', 'Fingers']),
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

# Create Japanese Skill Tree
# Return if it already exists
if SkillTree.find_by(name: "Japanese Language Learning")
  pp "Japanese Skill Tree already exists!"
  return
end

japanese_tree = SkillTree.create!(name: "Japanese Language Learning")

# Stats
alphabets = japanese_tree.stats.create!(name: "Alphabets")
vocabulary = japanese_tree.stats.create!(name: "Vocabulary")
grammar = japanese_tree.stats.create!(name: "Grammar")

# Alphabets Nodes
hiragana = japanese_tree.skill_nodes.create!(name: "Hiragana", description: "Learn the basic Japanese phonetic alphabet")
katakana = japanese_tree.skill_nodes.create!(name: "Katakana", description: "Learn the alphabet used for foreign words")
kanji = japanese_tree.skill_nodes.create!(name: "Kanji", description: "Learn Chinese characters used in Japanese")

# Create StatModifiers for Alphabet nodes
[ hiragana, katakana, kanji ].each do |node|
  StatModifier.create!(skill_node: node, stat: alphabets, value: 1)
end

# Hiragana Quests
hiragana.quests.create!([
  { name: "Translate Hiragana to Romanji", description: "Translate all Hiragana characters to Romanji", stat_reward: { alphabets: 1 } },
  { name: "Write Hiragana", description: "Practice writing all Hiragana characters", stat_reward: { alphabets: 1 } },
  { name: "Read Hiragana Words", description: "Read words written in Hiragana and translate to Romanji", stat_reward: { alphabets: 1 } },
  { name: "Write Romanji in Hiragana", description: "Write Romanji words in Hiragana", stat_reward: { alphabets: 1 } },
  { name: "Install Japanese Keyboard", description: "Set up a Japanese keyboard on your device", stat_reward: { alphabets: 1 } }
])

# Vocabulary Nodes
basic_vocab = japanese_tree.skill_nodes.create!(name: "Basic Vocabulary", description: "Learn essential Japanese vocabulary")
StatModifier.create!(skill_node: basic_vocab, stat: vocabulary, value: 1)

# Basic Vocabulary Sub-nodes
basic_vocab_topics = [
  "Greetings and Basic Politeness",
  "Personal Pronouns",
  "Numbers and Counting",
  "Common Verbs",
  "Everyday Objects",
  "Places",
  "Common Adjectives",
  "Days, Months, and Seasons",
  "Time Expressions",
  "Basic Questions",
  "Simple Emotions"
]

basic_vocab_topics.each do |topic|
  node = japanese_tree.skill_nodes.create!(name: topic, description: "Learn #{topic.downcase}")
  StatModifier.create!(skill_node: node, stat: vocabulary, value: 1)
end

# Basic Vocabulary Quests
basic_vocab.quests.create!([
  { name: "Read Children's Books", description: "Practice reading simple Japanese children's books", stat_reward: { vocabulary: 1 } },
  { name: "Self Introduction", description: "Prepare and practice a self-introduction in Japanese", stat_reward: { vocabulary: 1 } },
  { name: "Find a Pen Pal", description: "Find a Japanese pen pal and discuss simple topics", stat_reward: { vocabulary: 1 } }
])

# Grammar Nodes
grammar_nodes = [
  { name: "Particles (助詞, joshi)", description: "Learn about Japanese particles" },
  { name: "Politeness Levels (敬語, keigo)", description: "Understand different levels of politeness in Japanese" },
  { name: "Tenses", description: "Learn about Japanese verb tenses" },
  { name: "Negation", description: "Learn how to form negative sentences" },
  { name: "Adjectives", description: "Understand how to use adjectives in Japanese" },
  { name: "Word Order", description: "Learn about Japanese sentence structure (SOV)" },
  { name: "Conjugation", description: "Practice verb conjugation in Japanese" },
  { name: "Conditional", description: "Learn how to express conditional statements" }
]

grammar_nodes.each do |node_data|
  node = japanese_tree.skill_nodes.create!(name: node_data[:name], description: node_data[:description])
  StatModifier.create!(skill_node: node, stat: grammar, value: 1)
end

# Tenses Sub-nodes
tenses = SkillNode.find_by(name: "Tenses")
present_future = japanese_tree.skill_nodes.create!(name: "Present/Future", description: "Learn about present and future tenses")
past = japanese_tree.skill_nodes.create!(name: "Past", description: "Learn about past tense")
[ present_future, past ].each do |node|
  StatModifier.create!(skill_node: node, stat: grammar, value: 1)
end

# Word Order Sub-node
word_order = SkillNode.find_by(name: "Word Order")
sov = japanese_tree.skill_nodes.create!(name: "SOV: Subject-Object-Verb", description: "Understand the basic Japanese sentence structure")
StatModifier.create!(skill_node: sov, stat: grammar, value: 1)

# Create connections between nodes
Connection.create!([
  { skill_tree: japanese_tree, source_node: hiragana, target_node: katakana, required_to_unlock: true },
  { skill_tree: japanese_tree, source_node: katakana, target_node: kanji, required_to_unlock: true },
  { skill_tree: japanese_tree, source_node: hiragana, target_node: basic_vocab, required_to_unlock: true },
  { skill_tree: japanese_tree, source_node: basic_vocab, target_node: SkillNode.find_by(name: "Particles (助詞, joshi)"), required_to_unlock: true },
  { skill_tree: japanese_tree, source_node: SkillNode.find_by(name: "Particles (助詞, joshi)"), target_node: SkillNode.find_by(name: "Politeness Levels (敬語, keigo)"), required_to_unlock: true },
  { skill_tree: japanese_tree, source_node: SkillNode.find_by(name: "Particles (助詞, joshi)"), target_node: tenses, required_to_unlock: true },
  { skill_tree: japanese_tree, source_node: tenses, target_node: SkillNode.find_by(name: "Negation"), required_to_unlock: true },
  { skill_tree: japanese_tree, source_node: tenses, target_node: SkillNode.find_by(name: "Adjectives"), required_to_unlock: true },
  { skill_tree: japanese_tree, source_node: tenses, target_node: word_order, required_to_unlock: true },
  { skill_tree: japanese_tree, source_node: tenses, target_node: SkillNode.find_by(name: "Conjugation"), required_to_unlock: true },
  { skill_tree: japanese_tree, source_node: SkillNode.find_by(name: "Conjugation"), target_node: SkillNode.find_by(name: "Conditional"), required_to_unlock: true }
])

puts "Japanese Skill Tree created successfully!"

module RandomNameGenerator
  ALPHA = ('a'..'z').to_a

  def self.generate_fake_name(first_word_length=nil, second_word_length=nil)
    first_word_length  ||= rand(4..7)
    second_word_length ||= rand(4..7)

    first_word  = Array.new(first_word_length) { ALPHA.sample }.join
    second_word = Array.new(second_word_length) { ALPHA.sample }.join

    "#{first_word} #{second_word}"
  end
end

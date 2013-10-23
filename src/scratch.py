import csv
import nltk

def get_words_in_tweets(tweets):
    all_words = []
    for (words, sentiment) in tweets:
      all_words.extend(words)
    return all_words

def get_word_features(wordlist):
    wordlist = nltk.FreqDist(wordlist)
    word_features = wordlist.keys()
    return word_features

# Define the features used in the algorithm
def extract_features(document):
	document_words = set(document)
	features = {}
	for word in word_features:
		features['constains(%s)' % word] = (word in document_words)
	return features

def train(labeled_featuresets, estimator=nltk.ELEProbDist):
    # Create the P(label) distribution
    label_probdist = estimator(label_freqdist)
    # Create the P(fval|label, fname) distribution
    feature_probdist = {}
    return NaiveBayesClassifier(label_probdist, feature_probdist)



tweets = []
with open('../data/train_lite.csv', 'r') as csvfile:
	spamreader = csv.reader(csvfile, delimiter=',')
	next(spamreader, None)
	for row in spamreader:
		tokenizer = nltk.tokenize.RegexpTokenizer(r'\w{3,}')
		words_filtered = [w.lower() for w in tokenizer.tokenize(row[1])]
		tweets.append((words_filtered, (float(row[7]) - float(row[5]) > 0)))

word_features = get_word_features(get_words_in_tweets(tweets))
training_set = nltk.classify.apply_features(extract_features, tweets)
classifier = nltk.NaiveBayesClassifier.train(training_set)

# evaluate
tz = zip(*tweets)
[(classifier.classify(extract_features(p)), g) for p,g in zip(tz[0], tz[1])]
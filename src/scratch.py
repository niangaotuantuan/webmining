import csv
import nltk

"""
def get_wrods_level_tweets(tweets):
    all_words = []
    for (words, sentiment) in tweets:
      all_words.extend(words)
    return all_words
"""
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


def read_samples(dir):
    """
    Reads a sample file and return the splitted words for each tweets
    Remove stop words
    """

    samples = []
    with open(dir, 'r') as csvfile:
    	spamreader = csv.reader(csvfile, delimiter=',')
    	next(spamreader, None) # skip the header
        stopwords = nltk.corpus.stopwords.words('english')
    	for row in spamreader:
            # split and save all words that are longer than 3
    		tokenizer = nltk.tokenize.RegexpTokenizer(r'\w{3,}')
    		words_filtered = [w.lower() for w in tokenizer.tokenize(row[1]) if w.lower() not in stopwords]
            # mock dimension: positive - negative. Used in proof of concept
    		samples.append((words_filtered, (float(row[7]) - float(row[5]) > 0)))

    return samples

def evaluate(classifier, labelled_test_set):
    tz = zip(*labelled_test_set)
    rst = [(classifier.classify(extract_features(p)), g) for p,g in zip(tz[0], tz[1])]    
    print rst
    return rst

test_set = read_samples('../data/test_labelled.csv')
train_set = read_samples('../data/train_lite.csv')

#word_features = get_word_features(get_wrods_level_tweets(train_set))
training_feature_set = nltk.classify.apply_features(extract_features, train_set)
classifier = nltk.NaiveBayesClassifier.train(training_feature_set)

# evaluate
evaluate(classifier, test_set)
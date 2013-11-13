from sklearn.svm import LinearSVC
from nltk.classify.scikitlearn import SklearnClassifier
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_selection import SelectKBest, chi2
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline

execfile('scratch.py')

def tokenizer(text):
	tok = nltk.tokenize.RegexpTokenizer(r'\w{3,}')
	stopwords = nltk.corpus.stopwords.words('english')
	return [w.lower() for w in tok.tokenize(text) if w.lower() not in stopwords]

tweets = read_tweets('../data/train_lite.csv')
vec = TfidfVectorizer(tokenizer=tokenizer, max_features=50)
data = vec.fit_transform(tweets).toarray()

classifier = classif.train(training_feature_set)

train_set_words = [e[0] for e in train_set]
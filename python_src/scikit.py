from sklearn.decomposition import TruncatedSVD
from sklearn.svm import LinearSVC
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_selection import SelectKBest, chi2
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
from sklearn.svm import SVR
import numpy as np
import pandas
import matplotlib.pyplot as plt

execfile('scratch.py')

def tokenizer(text):
	tok = nltk.tokenize.RegexpTokenizer(r'\w{3,}')
	stopwords = nltk.corpus.stopwords.words('english')
	return [w.lower() for w in tok.tokenize(text) if w.lower() not in stopwords]

###############################################################
# Routines
##########
def read_dataset(input_filename):
	# Read files
	tweets = read_tweets(input_filename)
	labels = read_labels(input_filename)	

	# Get feature vectors by tf-idf
	vec = TfidfVectorizer(tokenizer=tokenizer, max_features=50)
	data = vec.fit_transform(tweets).toarray()

	return data, labels

# Train model
def train_model(train_data, train_labels, algo):
	if algo == 'svr_rbf':
		"""
		SVM regression
		"""
		svr_rbf = SVR(kernel='rbf', C=1e3, gamma=0.1)
		svr_rbf.fit(train_data, train_labels)
		return svr_rbf

	# No hit algorithm
	print "unimplemented model type"
	return None

# Get prediction
def get_prediction(model, test_data):
	return model.predict(test_data)

def evaluate_result(pred, test_labels):
	"""
	Evaluate the result. 
	Print stats description and return the error series
	"""
	npred = np.float32(np.array(pred))
	nlabels = np.float32(np.array(test_labels))

	s = Series(np.abs(nlabels - npred))
	s.describe()

	return s

# Main routine
def routine():
	# Prepare data
	data, labels = read_dataset('../data/train_lite_1000.csv')
	labels = zip(*labels)[0]
	# Seperate the test and train
	fold = int(len(data) * 0.9)
	train_data = data[0:fold]
	train_labels = labels[0:fold]
	test_data = data[fold+1:]
	test_labels = labels[fold+1:]
	
	# Train model
	model = train_model(train_data, train_labels, 'svr_rbf')

	# Get predict result
	result = get_prediction(model, test_data)

	# Evaluate result
	evaluate_result(result, test_labels)

	pass

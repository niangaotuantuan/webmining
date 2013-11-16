from sklearn.decomposition import TruncatedSVD
from sklearn.svm import LinearSVC
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_selection import SelectKBest, chi2
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
from sklearn.svm import SVR
from sklearn.linear_model import Ridge
import numpy as np
from pandas import Series
import matplotlib.pyplot as plt

from scratch import *

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
	"""
	Train the model
	"""
	if algo == 'svr_rbf':
		"""
		SVM regression, RBF kernel
		"""
		svr_rbf = SVR(kernel='rbf', C=1e3, gamma=0.1)
		svr_rbf.fit(train_data, train_labels)
		return svr_rbf

	if algo == 'svr_lin':
		"""
		SVM regression, linear
		"""
		svr_lin = SVR(kernel='linear')
		svr_lin.fit(train_data, train_labels)
		return svr_lin

	if algo == 'ridge':
		"""
		Ridge regression
		"""
		clf = Ridge(alpha = 0.5)
		clf.fit(train_data, train_labels)
		return clf

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
	print s.describe()
	print 

	return s

# Main routine
def routine(algo):
	# Calculate time
	import time
	start_time = time.time()

	# Prepare data
	data, labels = read_dataset('../data/train.csv')
	labels = zip(*labels)[0]
	# Seperate the test and train
	fold = int(len(data) * 0.9)
	train_data = data[0:fold]
	train_labels = labels[0:fold]
	test_data = data[fold+1:]
	test_labels = labels[fold+1:]
	
	# Train model
	model = train_model(train_data, train_labels, algo)

	# Get predict result
	result = get_prediction(model, test_data)

	# Evaluate result
	error_series = evaluate_result(result, test_labels)

	# Calculate time
	print 'Execution time: ', time.time() - start_time, 'seconds.'

	return error_series

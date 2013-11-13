from sklearn.svm import LinearSVC
from nltk.classify.scikitlearn import SklearnClassifier
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_selection import SelectKBest, chi2
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline

from sklearn.svm import SVR

execfile('scratch.py')

def tokenizer(text):
	tok = nltk.tokenize.RegexpTokenizer(r'\w{3,}')
	stopwords = nltk.corpus.stopwords.words('english')
	return [w.lower() for w in tok.tokenize(text) if w.lower() not in stopwords]


# Read files
input_filename = '../data/train_lite.csv'
tweets = read_tweets(input_filename)
labels = read_labels(input_filename)
# Get feature vectors by tf-idf
vec = TfidfVectorizer(tokenizer=tokenizer, max_features=50)
data = vec.fit_transform(tweets).toarray()

# SVM regression
svr_rbf = SVR(kernel='rbf', C=1e3)
label1 = zip(*labels)[0]
fold = int(len(data) * 0.9)
model_rbf = svr_rbf.fit(data[0:fold], label1[0:fold])
pred = model_rbf.predict(data[fold+1:])

# Evaluate
nlabel1 = np.float32(np.array(label1[fold+1:]))
npred = np.float32(np.array(pred))

nlabel1 - npred
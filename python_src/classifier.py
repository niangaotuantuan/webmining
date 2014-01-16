from account import Account
from models import Category, tweet, Comment

from main import Config
from itertools import chain

import sys
import logging
import thread

class Classifier():

    ''' classify tweet'''

    def __init__(self, category_id):
        self.category_id = category_id
        self.category = Category.objects.get(category_id=category_id)
        self.keyword_set = set()
        for keyword in self.category.keywords.split():
            logging.info('Adding %s to %s' % (keyword, self.category))
            self.keyword_set.add(keyword)
        logging.info('Init Classifier Over, with %d keywords imported in category %s'
                    % (len(self.keyword_set), self.category))

    def label_by_content(self, reset_all=False):
        '''
        Label tweet by it's content
        '''

        import jieba
        jieba.load_userdict("/etc/jieba/jieba.dic")


        logging.info('Start labeling tweets by content')
        page_id=0; page_size = 1000; over = False; cnt = 0

        while not over:

            if reset_all:
                # fetch all original tweet
                tweets = tweet.objects.filter(retweeted_status__exact=None)[page_id:page_id+page_size]
            else:
                # Only fetch original tweets have not been predicted before
                tweets = tweet.objects.filter(retweeted_status__exact=None)\
                        .filter(predict_category=0)[page_id:page_id+page_size]

            logging.info('Fetched %d tweets for labeling' % len(tweets))

            if not tweets or len(tweets)<page_size:
                over = True
            else:
                page_id += len(tweets)

            for tweet in tweets:

                retweet_statuses = tweet.retweet_status.all()
                # consider comments

                tweet.predict_category = Category.NO_CATEGORY # reset category

                content = tweet.text
                for rwb in retweet_statuses:
                    rwb.predict_category = Category.NO_CATEGORY
                    content += rwb.text

                logging.info(u'predicting %s(with %d retweets) -- %s' % (tweet, len(retweet_statuses), tweet.text))

                for word in jieba.cut(content.lower()):
                    # find one keyword, and classify in this category
                    if word in self.keyword_set:
                        logging.info(u'%s Predict %s belongs to %s' % (cnt, tweet, self.category))
                        tweet.predict_category = self.category_id
                        for rwb in retweet_statuses:
                            rwb.predict_category = self.category_id
                        cnt += 1
                        break
                tweet.save()

        logging.info('Labeled %d new tweet in %s' % (cnt, self.category))

    def label_by_user(self, threshold=3, reset_all=False):
        '''
        Label tweet By Users related
        '''

        logging.info('Start labeling tweets by users related to it')
        page_id=0; page_size = 1000; over = False;
        cnt0=0; cnt1=0

        while not over:

            if reset_all:
                # fetch all original tweet
                tweets = tweet.objects.filter(retweeted_status__exact=None)[page_id:page_id+page_size]
            else:
                # Only fetch original tweets have not been predicted before
                tweets = tweet.objects.filter(retweeted_status__exact=None)\
                        .filter(predict_category=0)[page_id:page_id+page_size]
						
            if not tweets or len(tweets)<page_size:
                over = True
            else:
                page_id += len(tweets)

            for tweet in tweets:

                logging.info("analyzing tweet:%s" % tweet)

                retweets = tweet.retweet_status.all()
                comments = tweet.comments.all()
                logging.info("%d retweets, %d comments" % (len(retweets), len(comments)))
                pos_cnt = 0; neg_cnt = 0
                for rt in list(chain(retweets, comments)):
                    if rt.owner.predict_category == self.category_id:
                        pos_cnt += 1
                    else:
                        neg_cnt += 1

                logging.info("%d positive users, %d negtive users" % (pos_cnt, neg_cnt))

                if pos_cnt>threshold:
                    cnt1+=1
                    logging.info("predict it as postive:%s" % tweet.text)
                    logging.info("pos/neg : %d/%d" % (cnt1, cnt0))
                    tweet.predict_category = self.category_id
                else:
                    cnt0+=1
                    logging.debug("predict it as negtive")
                    tweet.predict_category = Category.NO_CATEGORY# reset category

                tweet.save()

        logging.info('Labeled %d new tweet in %s' % ((cnt0+cnt1), self.category))



    def learn(self):
        pass

if __name__ == '__main__':
    classifier = Classifier(category_id=1)
    classifier.label_by_content()
    pass


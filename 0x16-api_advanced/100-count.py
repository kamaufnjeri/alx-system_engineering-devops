#!/usr/bin/python3
"""count the times a word appears in the title of a hot article"""
import requests


def count_words(subreddit, word_list, after=None, counts=None):
    if counts is None:
        counts = {}

    user_agent = 'Linux:Ubuntu/google'
    headers = {
        'User-Agent': user_agent
    }
    params = {
        'limit': 100,
        'after': after
    }
    url = f"https://www.reddit.com/r/{subreddit}/hot.json"

    response = requests.get(
            url, headers=headers,
            params=params, allow_redirects=False
            )

    if response.status_code != 200:
        return

    data = response.json().get('data', {})
    children = data.get('children', [])

    for child in children:
        title = child['data']['title'].lower()
        for word in word_list:
            if word.lower() in title:
                counts[word.lower()] = counts.get(word.lower(), 0) + 1

    after = data.get('after')
    if after:
        count_words(subreddit, word_list, after=after, counts=counts)
    else:
        sorted_counts = sorted(counts.items(), key=lambda x: (-x[1], x[0]))
        for word, count in sorted_counts:
            print(f"{word}: {count}")

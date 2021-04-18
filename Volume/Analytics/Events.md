# Events

| Name | Slug  | Description  | Parameters |
|---|---|---|---|
| StartOnboarding | start_onboarding | Begins onboarding process | | 
| CompleteOnboarding | complete_onboarding | Completes onboarding process | |
| OpenPublication | open_publication | Opens a publication page | publicationID, publicationEntrypoint |
| ClosePublication | close_publication | Closes a publication page | publicationID |
| FollowPublication | follow_publication | Follows a publication | publicationID, publicationEntrypoint |
| UnfollowPublication | unfollow_publication | Unfollows a publication | publicationID |
| OpenArticle | open_article | Opens an article | articleID, articleEntrypoint |
| CloseArticle | close_article | Closes an article through "<Back" button | articleID |
| ShareArticle | share_article | Shares an article | articleID |
| ShoutoutArticle | shoutout_article | Shoutouts an article | articleID |
| BookmarkArticle | bookmark_article | Bookmarks an article | articleID |
| | | | |

# Parameters
| Name | Slug | Description | Values |
|---|---|---|---|
| publicationID | publication | Publication UUID | |
| articleID | article | Article UUID | |
| articleEntrypoint | navigationSource | Location within app that user engages with Article from | publication_detail, trending_articles, following_articles, other_articles, bookmark_articles |
| publicationEntrypoint | navigationSource | Location within app that user engages with Publication from | article_detail, onboarding, following_publications, more_publications |
| | | | |


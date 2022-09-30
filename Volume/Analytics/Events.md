# Events

TODO: Update this to reflect latest analytics updates for notifications
| Name | Slug  | Description  | Parameters |
|---|---|---|---|
| StartOnboarding | start_onboarding | Begins onboarding process | | 
| CompleteOnboarding | complete_onboarding | Completes onboarding process | |
| OpenPublication | open_publication | Opens a publication page | publicationSlug, publicationEntrypoint |
| ClosePublication | close_publication | Closes a publication page | publicationSlug |
| FollowPublication | follow_publication | Follows a publication | publicationSlug, publicationEntrypoint |
| UnfollowPublication | unfollow_publication | Unfollows a publication | publicationSlug |
| OpenArticle | open_article | Opens an article | articleID, articleEntrypoint |
| CloseArticle | close_article | Closes an article through "<Back" button | articleID |
| ShareArticle | share_article | Shares an article | articleID |
| ShoutoutArticle | shoutout_article | Shoutouts an article | articleID |
| BookmarkArticle | bookmark_article | Bookmarks an article | articleID |
| | | | |

# Parameters
| Name | Slug | Description | Values |
|---|---|---|---|
| publicationSlug | publication | Publication unique shortened name | |
| articleID | article | Article UUID | |
| userID | userID | The user's device ID as a UUID; for data analytics | |
| articleEntrypoint | navigationSource | Location within app that user engages with Article from | publication_detail, trending_articles, following_articles, other_articles, bookmark_articles |
| publicationEntrypoint | navigationSource | Location within app that user engages with Publication from | article_detail, onboarding, following_publications, more_publications |
| | | | |


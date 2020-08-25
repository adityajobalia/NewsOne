const NewsAPI = require("newsapi");
import { v4 } from "uuid";
import { createRecord } from "../../Database/create";


export const fetchNews = async(event, context, callback) => {
    let newsCategories = [
        "science",
        "politics",
        "sports",
        "world",
        "education",
        "entertainment",
        "business",
        "technology",
        "travel",
        "fashion",
    ];
    const newsapi = new NewsAPI("9a697efbd13e4714b2f6e41fc008cdd1");
    // To query /v2/top-headlines
    // All options passed to topHeadlines are optional, but you need to include at least one of them
    //   let allArticles = [];

    for (let i = 0; i < newsCategories.length; i++) {
        let response = await newsapi.v2.topHeadlines({
            category: newsCategories[i],
            language: "en",
            country: "ca",
        });
        let articledateTime = new Date().getTime();
        // let articles = response.articles;

        for (let j = 0; j < response.articles.length; j++) {
            let article = response.articles[j];
        
            if (article.title == undefined || article.title == "" ||
                article.description == undefined || article.description == "" ||
                article.urlToImage == undefined || article.urlToImage == "" ||
               !(/^[a-zA-Z0-9 @!.#$%^&*(){}?/\<>:;+=-_|'-]*$/.test(article.title)) 
               || !(/^[a-zA-Z0-9 @!.#$%^&*(){}?/\<>:;+=-_|'-]*$/.test(article.description))
              || wordCounter(article.description) < 10
            ) {
                continue;
            }

            // let trimmedArticle = {};
            // trimmedArticle.sourceName = article.source.name;
            // trimmedArticle.auther = article.source.author;
            // trimmedArticle.title = article.source.title;
            // trimmedArticle.description = article.source.description;
            // trimmedArticle.url = article.source.url;
            // trimmedArticle.urlToImage = article.source.urlToImage;
            // trimmedArticle.category = category;
            // trimmedArticle.createdAt = articledateTime;
            // allArticles.push(trimmedArticle);

            let newsParams = {
                TableName: process.env.News,
                Item: {
                    newsid: v4(),
                    sourceName: article.source.name,
                    auther: article.author,
                    title: article.title,
                    description: article.description,
                    url: article.url,
                    urlToImage: article.urlToImage,
                    category: newsCategories[i],
                    createdAt: articledateTime,
                    discussions: []
                },
            };
            let dbRecord = await createRecord(newsParams);

        }
    }

    return {
        statusCode: 200,
        body: JSON.stringify({
            code: 0,
            message: "News Retrieved",
        }),
    };
};


function wordCounter(data){
  let words =  data.split(" ");
  return words.length;

}